package com.nihongo.backend.presentation.dto.response

data class GrammarResponse(
    val id: String?,
    val title: String,
    val structure: String,
    val meaning: String,
    val usage: String,
    val jlptLevel: Int,
    val formality: String,
    val examples: List<GrammarExampleResponse>,
    val relatedGrammar: List<String>,
    val tags: List<String>
)

data class GrammarExampleResponse(
    val japanese: String,
    val hiragana: String?,
    val vietnamese: String,
    val english: String?,
    val note: String?
)
