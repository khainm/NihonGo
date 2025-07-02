package com.nihongo.backend.presentation.dto.response

data class KanjiResponse(
    val id: String?,
    val character: String,
    val meaning: String,
    val meaningEn: String?,
    val onyomi: List<String>,
    val kunyomi: List<String>,
    val radicals: List<String>,
    val strokeCount: Int,
    val jlptLevel: Int,
    val frequency: Int?,
    val compounds: List<KanjiCompoundResponse>,
    val examples: List<KanjiExampleResponse>,
    val strokeOrder: List<String>,
    val mnemonics: String?,
    val tags: List<String>
)

data class KanjiCompoundResponse(
    val word: String,
    val reading: String,
    val meaning: String,
    val meaningEn: String?
)

data class KanjiExampleResponse(
    val sentence: String,
    val reading: String?,
    val meaning: String,
    val meaningEn: String?
)
