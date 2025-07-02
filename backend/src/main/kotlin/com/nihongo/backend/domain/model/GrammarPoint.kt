package com.nihongo.backend.domain.model

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document

@Document(collection = "grammar_points")
data class GrammarPoint(
    @Id
    val id: String? = null,
    val title: String,
    val structure: String,
    val meaning: String,
    val usage: String,
    val jlptLevel: Int, // 1-5
    val formality: GrammarFormality,
    val examples: List<GrammarExample> = emptyList(),
    val relatedGrammar: List<String> = emptyList(),
    val tags: List<String> = emptyList(),
    val createdAt: Long = System.currentTimeMillis()
)

data class GrammarExample(
    val japanese: String,
    val hiragana: String? = null,
    val vietnamese: String,
    val english: String? = null,
    val note: String? = null
)

enum class GrammarFormality {
    FORMAL, INFORMAL, BOTH
}
