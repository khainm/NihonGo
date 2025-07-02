// package com.nihongo.backend.application.service.mock

// import com.nihongo.backend.domain.model.*
// import com.nihongo.backend.presentation.dto.response.*
// import org.springframework.stereotype.Service

// @Service
// class MockVocabularyService {

//     fun getVocabulariesByLevel(
//         jlptLevel: Int,
//         page: Int = 0,
//         size: Int = 20,
//         category: String? = null
//     ): PaginatedResponse<VocabularyResponse> {
//         val mockData = getMockVocabularyData(jlptLevel)
//         val filtered = if (category != null) {
//             mockData.filter { it.category == category }
//         } else {
//             mockData
//         }
        
//         val startIndex = page * size
//         val endIndex = minOf(startIndex + size, filtered.size)
//         val pageData = if (startIndex < filtered.size) {
//             filtered.subList(startIndex, endIndex)
//         } else {
//             emptyList()
//         }
        
//         return PaginatedResponse(
//             items = pageData,
//             totalItems = filtered.size.toLong(),
//             currentPage = page,
//             totalPages = (filtered.size + size - 1) / size,
//             hasNext = endIndex < filtered.size,
//             hasPrevious = page > 0
//         )
//     }

//     fun searchVocabulary(keyword: String, page: Int = 0, size: Int = 20): PaginatedResponse<VocabularyResponse> {
//         val allData = (1..5).flatMap { getMockVocabularyData(it) }
//         val filtered = allData.filter { 
//             it.word.contains(keyword, ignoreCase = true) ||
//             it.meaning.contains(keyword, ignoreCase = true) ||
//             it.romanji.contains(keyword, ignoreCase = true)
//         }
        
//         val startIndex = page * size
//         val endIndex = minOf(startIndex + size, filtered.size)
//         val pageData = if (startIndex < filtered.size) {
//             filtered.subList(startIndex, endIndex)
//         } else {
//             emptyList()
//         }
        
//         return PaginatedResponse(
//             items = pageData,
//             totalItems = filtered.size.toLong(),
//             currentPage = page,
//             totalPages = (filtered.size + size - 1) / size,
//             hasNext = endIndex < filtered.size,
//             hasPrevious = page > 0
//         )
//     }

//     fun getVocabularyById(id: String): VocabularyResponse? {
//         val allData = (1..5).flatMap { getMockVocabularyData(it) }
//         return allData.find { it.id == id }
//     }

//     private fun getMockVocabularyData(jlptLevel: Int): List<VocabularyResponse> {
//         return when (jlptLevel) {
//             5 -> listOf(
//                 VocabularyResponse(
//                     id = "vocab_1",
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
//                     audioUrl = null,
//                     imageUrl = null,
//                     tags = listOf("greeting", "basic")
//                 ),
//                 VocabularyResponse(
//                     id = "vocab_2",
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
//                     audioUrl = null,
//                     imageUrl = null,
//                     tags = listOf("greeting", "gratitude")
//                 ),
//                 VocabularyResponse(
//                     id = "vocab_3",
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
//                     audioUrl = null,
//                     imageUrl = null,
//                     tags = listOf("education", "place")
//                 )
//             )
//             4 -> listOf(
//                 VocabularyResponse(
//                     id = "vocab_4",
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
//                     audioUrl = null,
//                     imageUrl = null,
//                     tags = listOf("weather", "nature")
//                 ),
//                 VocabularyResponse(
//                     id = "vocab_5",
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
//                     audioUrl = null,
//                     imageUrl = null,
//                     tags = listOf("education", "activity")
//                 )
//             )
//             3 -> listOf(
//                 VocabularyResponse(
//                     id = "vocab_6",
//                     word = "経験",
//                     hiragana = "けいけん",
//                     romanji = "keiken",
//                     meaning = "kinh nghiệm",
//                     meaningEn = "experience",
//                     jlptLevel = 3,
//                     category = "abstract",
//                     examples = listOf(
//                         ExampleResponse(
//                             japanese = "仕事の経験があります",
//                             hiragana = "しごとのけいけんがあります",
//                             vietnamese = "Có kinh nghiệm làm việc",
//                             english = "Have work experience"
//                         )
//                     ),
//                     audioUrl = null,
//                     imageUrl = null,
//                     tags = listOf("work", "life")
//                 )
//             )
//             else -> emptyList()
//         }
//     }
// }
