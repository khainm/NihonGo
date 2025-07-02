package com.nihongo.backend.application.service

import com.nihongo.backend.domain.model.Kanji
import com.nihongo.backend.domain.model.KanjiCompound
import com.nihongo.backend.domain.model.KanjiExample
import com.nihongo.backend.infrastructure.client.KanjiApiClient
import com.nihongo.backend.infrastructure.repository.KanjiRepository
import com.nihongo.backend.presentation.dto.response.KanjiResponse
import com.nihongo.backend.presentation.dto.response.KanjiCompoundResponse
import com.nihongo.backend.presentation.dto.response.KanjiExampleResponse
import com.nihongo.backend.presentation.dto.response.PaginatedResponse
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.cache.annotation.Cacheable

@Service
class KanjiService(
    private val kanjiRepository: KanjiRepository,
    private val kanjiApiClient: KanjiApiClient
) {

    @Cacheable("kanji")
    fun getKanjiByLevel(jlptLevel: Int, page: Int = 0, size: Int = 20): PaginatedResponse<KanjiResponse> {
        val pageable = PageRequest.of(page, size, Sort.by("character"))
        var kanjiPage = kanjiRepository.findByJlptLevel(jlptLevel, pageable)
        
        // If no data in database, create sample data
        if (kanjiPage.isEmpty) {
            createSampleKanjiData(jlptLevel)
            kanjiPage = kanjiRepository.findByJlptLevel(jlptLevel, pageable)
        }
        
        return createPaginatedResponse(kanjiPage)
    }

    fun searchKanji(keyword: String, page: Int = 0, size: Int = 20): PaginatedResponse<KanjiResponse> {
        val pageable = PageRequest.of(page, size)
        var kanjiPage = kanjiRepository.searchByCharacterOrMeaning(keyword, pageable)
        
        // If no results and keyword is single character, try API
        if (kanjiPage.isEmpty && keyword.length == 1) {
            fetchKanjiFromApi(keyword)
            kanjiPage = kanjiRepository.searchByCharacterOrMeaning(keyword, pageable)
        }
        
        return createPaginatedResponse(kanjiPage)
    }

    fun getKanjiById(id: String): KanjiResponse? {
        val kanji = kanjiRepository.findById(id).orElse(null)
        return kanji?.let { mapToResponse(it) }
    }

    fun getKanjiByStrokeCount(minStrokes: Int, maxStrokes: Int, page: Int = 0, size: Int = 20): PaginatedResponse<KanjiResponse> {
        val pageable = PageRequest.of(page, size, Sort.by("strokeCount"))
        val kanjiPage = kanjiRepository.findByStrokeCountBetween(minStrokes, maxStrokes, pageable)
        return createPaginatedResponse(kanjiPage)
    }

    private fun fetchKanjiFromApi(character: String) {
        try {
            val response = kanjiApiClient.getKanji(character).block()
            response?.let { apiResponse ->
                if (apiResponse.kanji.isNotEmpty()) {
                    val kanji = Kanji(
                        character = apiResponse.kanji,
                        meaning = translateToVietnamese(apiResponse.meanings.joinToString(", ")),
                        meaningEn = apiResponse.meanings.joinToString(", "),
                        onyomi = apiResponse.onReadings,
                        kunyomi = apiResponse.kunReadings,
                        strokeCount = apiResponse.strokeCount,
                        jlptLevel = apiResponse.jlpt ?: 5,
                        tags = listOf("api-fetched")
                    )
                    kanjiRepository.save(kanji)
                }
            }
        } catch (e: Exception) {
            // Log error and continue
        }
    }

    private fun createSampleKanjiData(jlptLevel: Int) {
        val kanjiData = getSampleKanjiData(jlptLevel)
        kanjiRepository.saveAll(kanjiData)
    }

    private fun getSampleKanjiData(jlptLevel: Int): List<Kanji> {
        return when (jlptLevel) {
            5 -> listOf(
                Kanji(
                    character = "人",
                    meaning = "người",
                    meaningEn = "person",
                    onyomi = listOf("ジン", "ニン"),
                    kunyomi = listOf("ひと"),
                    radicals = listOf("人"),
                    strokeCount = 2,
                    jlptLevel = 5,
                    frequency = 1,
                    compounds = listOf(
                        KanjiCompound(
                            word = "人間",
                            reading = "にんげん",
                            meaning = "con người",
                            meaningEn = "human being"
                        ),
                        KanjiCompound(
                            word = "日本人",
                            reading = "にほんじん",
                            meaning = "người Nhật",
                            meaningEn = "Japanese person"
                        )
                    ),
                    examples = listOf(
                        KanjiExample(
                            sentence = "この人は先生です。",
                            reading = "このひとはせんせいです。",
                            meaning = "Người này là giáo viên.",
                            meaningEn = "This person is a teacher."
                        )
                    ),
                    mnemonics = "Hình ảnh một người đang đi với hai chân",
                    tags = listOf("basic", "people")
                ),
                Kanji(
                    character = "日",
                    meaning = "ngày, mặt trời",
                    meaningEn = "day, sun",
                    onyomi = listOf("ニチ", "ジツ"),
                    kunyomi = listOf("ひ", "か"),
                    radicals = listOf("日"),
                    strokeCount = 4,
                    jlptLevel = 5,
                    frequency = 2,
                    compounds = listOf(
                        KanjiCompound(
                            word = "今日",
                            reading = "きょう",
                            meaning = "hôm nay",
                            meaningEn = "today"
                        ),
                        KanjiCompound(
                            word = "日本",
                            reading = "にほん",
                            meaning = "Nhật Bản",
                            meaningEn = "Japan"
                        )
                    ),
                    examples = listOf(
                        KanjiExample(
                            sentence = "今日は晴れです。",
                            reading = "きょうははれです。",
                            meaning = "Hôm nay trời nắng.",
                            meaningEn = "Today is sunny."
                        )
                    ),
                    mnemonics = "Hình ảnh mặt trời với một vạch ngang ở giữa",
                    tags = listOf("basic", "time", "sun")
                ),
                Kanji(
                    character = "本",
                    meaning = "sách, gốc",
                    meaningEn = "book, origin",
                    onyomi = listOf("ホン"),
                    kunyomi = listOf("もと"),
                    radicals = listOf("木"),
                    strokeCount = 5,
                    jlptLevel = 5,
                    frequency = 3,
                    compounds = listOf(
                        KanjiCompound(
                            word = "本当",
                            reading = "ほんとう",
                            meaning = "thật sự",
                            meaningEn = "really"
                        ),
                        KanjiCompound(
                            word = "教科書",
                            reading = "きょうかしょ",
                            meaning = "sách giáo khoa",
                            meaningEn = "textbook"
                        )
                    ),
                    examples = listOf(
                        KanjiExample(
                            sentence = "この本は面白いです。",
                            reading = "このほんはおもしろいです。",
                            meaning = "Cuốn sách này thú vị.",
                            meaningEn = "This book is interesting."
                        )
                    ),
                    mnemonics = "Cây (木) với một vạch ngang ở dưới chỉ gốc",
                    tags = listOf("basic", "book", "origin")
                )
            )
            4 -> listOf(
                Kanji(
                    character = "学",
                    meaning = "học",
                    meaningEn = "study, learn",
                    onyomi = listOf("ガク"),
                    kunyomi = listOf("まな"),
                    radicals = listOf("子"),
                    strokeCount = 8,
                    jlptLevel = 4,
                    frequency = 10,
                    compounds = listOf(
                        KanjiCompound(
                            word = "学生",
                            reading = "がくせい",
                            meaning = "học sinh",
                            meaningEn = "student"
                        ),
                        KanjiCompound(
                            word = "大学",
                            reading = "だいがく",
                            meaning = "đại học",
                            meaningEn = "university"
                        )
                    ),
                    examples = listOf(
                        KanjiExample(
                            sentence = "毎日日本語を学んでいます。",
                            reading = "まいにちにほんごをまなんでいます。",
                            meaning = "Hàng ngày tôi học tiếng Nhật.",
                            meaningEn = "I study Japanese every day."
                        )
                    ),
                    mnemonics = "Trẻ em (子) học tập dưới mái nhà",
                    tags = listOf("education", "study")
                ),
                Kanji(
                    character = "時",
                    meaning = "thời gian",
                    meaningEn = "time",
                    onyomi = listOf("ジ"),
                    kunyomi = listOf("とき"),
                    radicals = listOf("日"),
                    strokeCount = 10,
                    jlptLevel = 4,
                    frequency = 15,
                    compounds = listOf(
                        KanjiCompound(
                            word = "時間",
                            reading = "じかん",
                            meaning = "thời gian",
                            meaningEn = "time"
                        ),
                        KanjiCompound(
                            word = "時計",
                            reading = "とけい",
                            meaning = "đồng hồ",
                            meaningEn = "clock, watch"
                        )
                    ),
                    examples = listOf(
                        KanjiExample(
                            sentence = "時間がありません。",
                            reading = "じかんがありません。",
                            meaning = "Không có thời gian.",
                            meaningEn = "There is no time."
                        )
                    ),
                    mnemonics = "Mặt trời (日) với chùm (寺) - thời gian trôi qua",
                    tags = listOf("time", "temporal")
                )
            )
            else -> emptyList()
        }
    }

    private fun translateToVietnamese(englishText: String): String {
        val translations = mapOf(
            "person" to "người",
            "day" to "ngày",
            "sun" to "mặt trời",
            "book" to "sách",
            "origin" to "gốc",
            "study" to "học",
            "learn" to "học",
            "time" to "thời gian",
            "year" to "năm",
            "month" to "tháng",
            "water" to "nước",
            "fire" to "lửa",
            "earth" to "đất",
            "tree" to "cây",
            "metal" to "kim loại"
        )
        return englishText.split(", ").joinToString(", ") { word ->
            translations[word.lowercase().trim()] ?: word
        }
    }

    private fun createPaginatedResponse(page: org.springframework.data.domain.Page<Kanji>): PaginatedResponse<KanjiResponse> {
        return PaginatedResponse(
            items = page.content.map { mapToResponse(it) },
            totalItems = page.totalElements,
            currentPage = page.number,
            totalPages = page.totalPages,
            hasNext = page.hasNext(),
            hasPrevious = page.hasPrevious()
        )
    }

    private fun mapToResponse(kanji: Kanji): KanjiResponse {
        return KanjiResponse(
            id = kanji.id,
            character = kanji.character,
            meaning = kanji.meaning,
            meaningEn = kanji.meaningEn,
            onyomi = kanji.onyomi,
            kunyomi = kanji.kunyomi,
            radicals = kanji.radicals,
            strokeCount = kanji.strokeCount,
            jlptLevel = kanji.jlptLevel,
            frequency = kanji.frequency,
            compounds = kanji.compounds.map {
                KanjiCompoundResponse(
                    word = it.word,
                    reading = it.reading,
                    meaning = it.meaning,
                    meaningEn = it.meaningEn
                )
            },
            examples = kanji.examples.map {
                KanjiExampleResponse(
                    sentence = it.sentence,
                    reading = it.reading,
                    meaning = it.meaning,
                    meaningEn = it.meaningEn
                )
            },
            strokeOrder = kanji.strokeOrder,
            mnemonics = kanji.mnemonics,
            tags = kanji.tags
        )
    }
}
