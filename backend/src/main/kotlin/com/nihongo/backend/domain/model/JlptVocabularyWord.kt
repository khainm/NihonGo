package com.nihongo.backend.domain.model

data class JlptVocabularyWord(
    val id: String,
    val japanese: String,
    val vietnamese: String,
    val reading: String? = null,
    val romaji: String? = null,
    val wordType: String? = null,
    val example: String? = null
)
