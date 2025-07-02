// package com.nihongo.backend.application.service

// import com.nihongo.backend.presentation.dto.response.VocabularyResponse
// import com.nihongo.backend.presentation.dto.response.ExampleResponse
// import com.nihongo.backend.presentation.dto.response.PaginatedResponse
// import org.springframework.stereotype.Service
// import java.util.*

// @Service
// class VocabularyService {

//     fun getVocabulariesByLevel(
//         jlptLevel: Int,
//         page: Int = 0,
//         size: Int = 20,
//         category: String? = null
//     ): PaginatedResponse<VocabularyResponse> {
//         val allVocabularies = getSampleVocabularyData(jlptLevel, category)
        
//         val startIndex = page * size
//         val endIndex = minOf(startIndex + size, allVocabularies.size)
//         val pageItems = if (startIndex < allVocabularies.size) {
//             allVocabularies.subList(startIndex, endIndex)
//         } else {
//             emptyList()
//         }
        
//         val totalPages = (allVocabularies.size + size - 1) / size
        
//         return PaginatedResponse(
//             items = pageItems,
//             totalItems = allVocabularies.size.toLong(),
//             currentPage = page,
//             totalPages = totalPages,
//             hasNext = page < totalPages - 1,
//             hasPrevious = page > 0
//         )
//     }

//     fun searchVocabulary(keyword: String, page: Int = 0, size: Int = 20): PaginatedResponse<VocabularyResponse> {
//         val allVocabularies = getAllVocabularies()
//         val filteredVocabularies = allVocabularies.filter { vocab ->
//             vocab.word.contains(keyword, ignoreCase = true) ||
//             vocab.meaning.contains(keyword, ignoreCase = true) ||
//             vocab.romanji.contains(keyword, ignoreCase = true) ||
//             vocab.hiragana?.contains(keyword, ignoreCase = true) == true
//         }
        
//         val startIndex = page * size
//         val endIndex = minOf(startIndex + size, filteredVocabularies.size)
//         val pageItems = if (startIndex < filteredVocabularies.size) {
//             filteredVocabularies.subList(startIndex, endIndex)
//         } else {
//             emptyList()
//         }
        
//         val totalPages = (filteredVocabularies.size + size - 1) / size
        
//         return PaginatedResponse(
//             items = pageItems,
//             totalItems = filteredVocabularies.size.toLong(),
//             currentPage = page,
//             totalPages = totalPages,
//             hasNext = page < totalPages - 1,
//             hasPrevious = page > 0
//         )
//     }

//     fun getVocabularyById(id: String): VocabularyResponse? {
//         return getAllVocabularies().find { it.id == id }
//     }

//     private fun getAllVocabularies(): List<VocabularyResponse> {
//         val allVocabs = mutableListOf<VocabularyResponse>()
//         for (level in 1..5) {
//             allVocabs.addAll(getSampleVocabularyData(level, null))
//         }
//         return allVocabs
//     }

//     private fun getSampleVocabularyData(jlptLevel: Int, category: String?): List<VocabularyResponse> {
//         val vocabularies = when (jlptLevel) {
//             5 -> listOf(
//                 VocabularyResponse(
//                     id = "vocab_001",
//                     word = "こんにちは",
//                     hiragana = "こんにちは",
//                     romanji = "konnichiwa",
//                     meaning = "xin chào",
//                     meaningEn = "hello",
//                     jlptLevel = 5,
//                     category = "greeting",
//                     examples = listOf(
//                         ExampleResponse(
//                             japanese = "こんにちは、元気ですか？",
//                             hiragana = "こんにちは、げんきですか？",
//                             vietnamese = "Xin chào, bạn có khỏe không?",
//                             english = "Hello, how are you?"
//                         )
//                     ),
//                     audioUrl = "https://example.com/audio/konnichiwa.mp3",
//                     imageUrl = null,
//                     tags = listOf("greeting", "basic")
//                 ),
//                 VocabularyResponse(
//                     id = "vocab_002",
//                     word = "ありがとう",
//                     hiragana = "ありがとう",
//                     romanji = "arigatou",
//                     meaning = "cảm ơn",
//                     meaningEn = "thank you",
//                     jlptLevel = 5,
//                     category = "greeting",
//                     examples = listOf(
//                         ExampleResponse(
//                             japanese = "ありがとうございます",
//                             hiragana = "ありがとうございます",
//                             vietnamese = "Cảm ơn (lịch sự)",
//                             english = "Thank you (polite)"
//                         )
//                     ),
//                     audioUrl = "https://example.com/audio/arigatou.mp3",
//                     imageUrl = null,
//                     tags = listOf("greeting", "gratitude")
//                 ),
//                 VocabularyResponse(
//                     id = "vocab_003",
//                     word = "学校",
//                     hiragana = "がっこう",
//                     romanji = "gakkou",
//                     meaning = "trường học",
//                     meaningEn = "school",
//                     jlptLevel = 5,
//                     category = "education",
//                     examples = listOf(
//                         ExampleResponse(
//                             japanese = "学校に行きます",
//                             hiragana = "がっこうにいきます",
//                             vietnamese = "Đi tới trường",
//                             english = "Go to school"
//                         )
//                     ),
//                     audioUrl = "https://example.com/audio/gakkou.mp3",
//                     imageUrl = null,
//                     tags = listOf("education", "place")
//                 ),
//                 VocabularyResponse(
//                     id = "vocab_004",
//                     word = "水",
//                     hiragana = "みず",
//                     romanji = "mizu",
//                     meaning = "nước",
//                     meaningEn = "water",
//                     jlptLevel = 5,
//                     category = "nature",
//                     examples = listOf(
//                         ExampleResponse(
//                             japanese = "水を飲みます",
//                             hiragana = "みずをのみます",
//                             vietnamese = "Uống nước",
//                             english = "Drink water"
//                         )
//                     ),
//                     audioUrl = "https://example.com/audio/mizu.mp3",
//                     imageUrl = null,
//                     tags = listOf("nature", "drink")
//                 ),
//                 VocabularyResponse(
//                     id = "vocab_005",
//                     word = "食べ物",
//                     hiragana = "たべもの",
//                     romanji = "tabemono",
//                     meaning = "thức ăn",
//                     meaningEn = "food",
//                     jlptLevel = 5,
//                     category = "food",
//                     examples = listOf(
//                         ExampleResponse(
//                             japanese = "日本の食べ物が好きです",
//                             hiragana = "にほんのたべものがすきです",
//                             vietnamese = "Tôi thích thức ăn Nhật",
//                             english = "I like Japanese food"
//                         )
//                     ),
//                     audioUrl = "https://example.com/audio/tabemono.mp3",
//                     imageUrl = null,
//                     tags = listOf("food", "basic")
//                 )
//             )
//             4 -> listOf(
//                 VocabularyResponse(
//                     id = "vocab_101",
//                     word = "天気",
//                     hiragana = "てんき",
//                     romanji = "tenki",
//                     meaning = "thời tiết",
//                     meaningEn = "weather",
//                     jlptLevel = 4,
//                     category = "nature",
//                     examples = listOf(
//                         ExampleResponse(
//                             japanese = "今日の天気はいいです",
//                             hiragana = "きょうのてんきはいいです",
//                             vietnamese = "Thời tiết hôm nay tốt",
//                             english = "Today's weather is good"
//                         )
//                     ),
//                     audioUrl = "https://example.com/audio/tenki.mp3",
//                     imageUrl = null,
//                     tags = listOf("weather", "nature")
//                 ),
//                 VocabularyResponse(
//                     id = "vocab_102",
//                     word = "勉強",
//                     hiragana = "べんきょう",
//                     romanji = "benkyou",
//                     meaning = "học tập",
//                     meaningEn = "study",
//                     jlptLevel = 4,
//                     category = "education",
//                     examples = listOf(
//                         ExampleResponse(
//                             japanese = "日本語を勉強します",
//                             hiragana = "にほんごをべんきょうします",
//                             vietnamese = "Học tiếng Nhật",
//                             english = "Study Japanese"
//                         )
//                     ),
//                     audioUrl = "https://example.com/audio/benkyou.mp3",
//                     imageUrl = null,
//                     tags = listOf("education", "activity")
//                 ),
//                 VocabularyResponse(
//                     id = "vocab_103",
//                     word = "友達",
//                     hiragana = "ともだち",
//                     romanji = "tomodachi",
//                     meaning = "bạn bè",
//                     meaningEn = "friend",
//                     jlptLevel = 4,
//                     category = "family",
//                     examples = listOf(
//                         ExampleResponse(
//                             japanese = "友達と映画を見ました",
//                             hiragana = "ともだちとえいがをみました",
//                             vietnamese = "Đã xem phim với bạn",
//                             english = "Watched a movie with friends"
//                         )
//                     ),
//                     audioUrl = "https://example.com/audio/tomodachi.mp3",
//                     imageUrl = null,
//                     tags = listOf("relationship", "people")
//                 )
//             )
//             3 -> listOf(
//                 VocabularyResponse(
//                     id = "vocab_201",
//                     word = "経験",
//                     hiragana = "けいけん",
//                     romanji = "keiken",
//                     meaning = "kinh nghiệm",
//                     meaningEn = "experience",
//                     jlptLevel = 3,
//                     category = "activities",
//                     examples = listOf(
//                         ExampleResponse(
//                             japanese = "仕事の経験があります",
//                             hiragana = "しごとのけいけんがあります",
//                             vietnamese = "Có kinh nghiệm làm việc",
//                             english = "Have work experience"
//                         )
//                     ),
//                     audioUrl = "https://example.com/audio/keiken.mp3",
//                     imageUrl = null,
//                     tags = listOf("work", "skill")
//                 )
//             )
//             else -> emptyList()
//         }
        
//         return if (category != null) {
//             vocabularies.filter { it.category == category }
//         } else {
//             vocabularies
//         }
//     }
// }
