package com.nihongo.backend.domain.model

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document

@Document(collection = "vocabularies")
data class Vocabulary(
    @Id
    val id: String? = null,
    val word: String,
    val hiragana: String? = null,
    val romanji: String,
    val meaning: String,
    val meaningEn: String? = null,
    val jlptLevel: Int, // 1-5
    val category: String,
    val examples: List<Example> = emptyList(),
    val audioUrl: String? = null,
    val imageUrl: String? = null,
    val tags: List<String> = emptyList(),
    val createdAt: Long = System.currentTimeMillis()
)

data class Example(
    val japanese: String,
    val hiragana: String? = null,
    val vietnamese: String,
    val english: String? = null
)
