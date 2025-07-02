package com.nihongo.backend.application.service

import com.nihongo.backend.domain.model.Vocabulary
import com.nihongo.backend.domain.model.Example
import com.nihongo.backend.infrastructure.client.JishoApiClient
import com.nihongo.backend.infrastructure.repository.VocabularyRepository
import com.nihongo.backend.presentation.dto.response.VocabularyResponse
import com.nihongo.backend.presentation.dto.response.ExampleResponse
import com.nihongo.backend.presentation.dto.response.PaginatedResponse
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.cache.annotation.Cacheable

@Service
class VocabularyService(
    private val vocabularyRepository: VocabularyRepository,
    private val jishoApiClient: JishoApiClient
) {

    @Cacheable("vocabularies")
    fun getVocabulariesByLevel(
        jlptLevel: Int,
        page: Int = 0,
        size: Int = 20,
        category: String? = null
    ): PaginatedResponse<VocabularyResponse> {
        val pageable = PageRequest.of(page, size, Sort.by("word"))
        
        val vocabularyPage = if (category != null) {
            vocabularyRepository.findByJlptLevelAndCategory(jlptLevel, category, pageable)
        } else {
            vocabularyRepository.findByJlptLevel(jlptLevel, pageable)
        }
        
        // If no data in database, fetch from external API
        if (vocabularyPage.isEmpty) {
            fetchAndSaveVocabulariesFromApi(jlptLevel, category)
            // Re-query after fetching
            val newPage = if (category != null) {
                vocabularyRepository.findByJlptLevelAndCategory(jlptLevel, category, pageable)
            } else {
                vocabularyRepository.findByJlptLevel(jlptLevel, pageable)
            }
            return createPaginatedResponse(newPage)
        }
        
        return createPaginatedResponse(vocabularyPage)
    }

    fun searchVocabulary(keyword: String, page: Int = 0, size: Int = 20): PaginatedResponse<VocabularyResponse> {
        val pageable = PageRequest.of(page, size)
        val vocabularyPage = vocabularyRepository.searchByKeyword(keyword, pageable)
        
        // If no results in database, try fetching from API
        if (vocabularyPage.isEmpty) {
            fetchVocabularyFromJisho(keyword)
            val newPage = vocabularyRepository.searchByKeyword(keyword, pageable)
            return createPaginatedResponse(newPage)
        }
        
        return createPaginatedResponse(vocabularyPage)
    }

    fun getVocabularyById(id: String): VocabularyResponse? {
        val vocabulary = vocabularyRepository.findById(id).orElse(null)
        return vocabulary?.let { mapToResponse(it) }
    }

    private fun fetchAndSaveVocabulariesFromApi(jlptLevel: Int, category: String?) {
        // Sample vocabulary data for different JLPT levels
        val vocabularyData = getSampleVocabularyData(jlptLevel, category)
        vocabularyRepository.saveAll(vocabularyData)
    }

    private fun fetchVocabularyFromJisho(keyword: String) {
        try {
            println("Fetching from Jisho API for keyword: $keyword")
            val response = jishoApiClient.searchWord(keyword).block()
            println("Jisho API response: ${response?.data?.size} items found")
            response?.data?.take(5)?.forEach { jishoData ->
                if (jishoData.japanese.isNotEmpty() && jishoData.senses.isNotEmpty()) {
                    println("Processing Jisho data: word=${jishoData.japanese.firstOrNull()?.word}, reading=${jishoData.japanese.firstOrNull()?.reading}")
                    val vocabulary = Vocabulary(
                        word = jishoData.japanese.firstOrNull()?.word ?: "",
                        hiragana = jishoData.japanese.firstOrNull()?.reading,
                        romanji = jishoData.japanese.firstOrNull()?.reading ?: "",
                        meaning = translateToVietnamese(jishoData.senses.first().englishDefinitions.joinToString(", ")),
                        meaningEn = jishoData.senses.first().englishDefinitions.joinToString(", "),
                        jlptLevel = extractJlptLevel(jishoData.jlpt),
                        category = jishoData.senses.first().partsOfSpeech.firstOrNull() ?: "other",
                        tags = jishoData.tags
                    )
                    println("Saving vocabulary: ${vocabulary.word}")
                    vocabularyRepository.save(vocabulary)
                }
            }
        } catch (e: Exception) {
            println("Error fetching from Jisho API: ${e.message}")
            e.printStackTrace()
        }
    }

    private fun getSampleVocabularyData(jlptLevel: Int, category: String?): List<Vocabulary> {
        return when (jlptLevel) {
            5 -> listOf(
                Vocabulary(
                    word = "こんにちは",
                    hiragana = "こんにちは",
                    romanji = "konnichiwa",
                    meaning = "xin chào",
                    meaningEn = "hello",
                    jlptLevel = 5,
                    category = "greeting",
                    examples = listOf(
                        Example(
                            japanese = "こんにちは、元気ですか？",
                            hiragana = "こんにちは、げんきですか？",
                            vietnamese = "Xin chào, bạn có khỏe không?",
                            english = "Hello, how are you?"
                        )
                    ),
                    tags = listOf("greeting", "basic")
                ),
                Vocabulary(
                    word = "ありがとう",
                    hiragana = "ありがとう",
                    romanji = "arigatou",
                    meaning = "cảm ơn",
                    meaningEn = "thank you",
                    jlptLevel = 5,
                    category = "greeting",
                    examples = listOf(
                        Example(
                            japanese = "ありがとうございます",
                            hiragana = "ありがとうございます",
                            vietnamese = "Cảm ơn (lịch sự)",
                            english = "Thank you (polite)"
                        )
                    ),
                    tags = listOf("greeting", "gratitude")
                ),
                Vocabulary(
                    word = "学校",
                    hiragana = "がっこう",
                    romanji = "gakkou",
                    meaning = "trường học",
                    meaningEn = "school",
                    jlptLevel = 5,
                    category = "education",
                    examples = listOf(
                        Example(
                            japanese = "学校に行きます",
                            hiragana = "がっこうにいきます",
                            vietnamese = "Đi tới trường",
                            english = "Go to school"
                        )
                    ),
                    tags = listOf("education", "place")
                )
            )
            4 -> listOf(
                Vocabulary(
                    word = "天気",
                    hiragana = "てんき",
                    romanji = "tenki",
                    meaning = "thời tiết",
                    meaningEn = "weather",
                    jlptLevel = 4,
                    category = "nature",
                    examples = listOf(
                        Example(
                            japanese = "今日の天気はいいです",
                            hiragana = "きょうのてんきはいいです",
                            vietnamese = "Thời tiết hôm nay tốt",
                            english = "Today's weather is good"
                        )
                    ),
                    tags = listOf("weather", "nature")
                ),
                Vocabulary(
                    word = "勉強",
                    hiragana = "べんきょう",
                    romanji = "benkyou",
                    meaning = "học tập",
                    meaningEn = "study",
                    jlptLevel = 4,
                    category = "education",
                    examples = listOf(
                        Example(
                            japanese = "日本語を勉強します",
                            hiragana = "にほんごをべんきょうします",
                            vietnamese = "Học tiếng Nhật",
                            english = "Study Japanese"
                        )
                    ),
                    tags = listOf("education", "activity")
                )
            )
            else -> emptyList()
        }
    }

    private fun translateToVietnamese(englishText: String): String {
        // Simple translation mapping - in real app, you'd use translation API
        val translations = mapOf(
            "hello" to "xin chào",
            "thank you" to "cảm ơn",
            "school" to "trường học",
            "weather" to "thời tiết",
            "study" to "học tập",
            "good" to "tốt",
            "house" to "nhà",
            "water" to "nước",
            "food" to "thức ăn"
        )
        return translations[englishText.lowercase()] ?: englishText
    }

    private fun extractJlptLevel(jlpt: List<String>): Int {
        return jlpt.firstOrNull()?.let { level ->
            when {
                level.contains("5") -> 5
                level.contains("4") -> 4
                level.contains("3") -> 3
                level.contains("2") -> 2
                level.contains("1") -> 1
                else -> 5
            }
        } ?: 5
    }

    private fun createPaginatedResponse(page: org.springframework.data.domain.Page<Vocabulary>): PaginatedResponse<VocabularyResponse> {
        return PaginatedResponse(
            items = page.content.map { mapToResponse(it) },
            totalItems = page.totalElements,
            currentPage = page.number,
            totalPages = page.totalPages,
            hasNext = page.hasNext(),
            hasPrevious = page.hasPrevious()
        )
    }

    private fun mapToResponse(vocabulary: Vocabulary): VocabularyResponse {
        return VocabularyResponse(
            id = vocabulary.id,
            word = vocabulary.word,
            hiragana = vocabulary.hiragana,
            romanji = vocabulary.romanji,
            meaning = vocabulary.meaning,
            meaningEn = vocabulary.meaningEn,
            jlptLevel = vocabulary.jlptLevel,
            category = vocabulary.category,
            examples = vocabulary.examples.map { 
                ExampleResponse(
                    japanese = it.japanese,
                    hiragana = it.hiragana,
                    vietnamese = it.vietnamese,
                    english = it.english
                )
            },
            audioUrl = vocabulary.audioUrl,
            imageUrl = vocabulary.imageUrl,
            tags = vocabulary.tags
        )
    }
}
