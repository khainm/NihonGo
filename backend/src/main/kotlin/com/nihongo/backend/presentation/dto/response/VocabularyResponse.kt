package com.nihongo.backend.presentation.dto.response

data class VocabularyResponse(
    val id: String?,
    val word: String,
    val hiragana: String?,
    val romanji: String,
    val meaning: String,
    val meaningEn: String?,
    val jlptLevel: Int,
    val category: String,
    val examples: List<ExampleResponse>,
    val audioUrl: String?,
    val imageUrl: String?,
    val tags: List<String>
)

data class ExampleResponse(
    val japanese: String,
    val hiragana: String?,
    val vietnamese: String,
    val english: String?
)
