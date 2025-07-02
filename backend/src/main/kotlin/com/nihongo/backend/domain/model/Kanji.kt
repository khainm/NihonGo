package com.nihongo.backend.domain.model

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document

@Document(collection = "kanji")
data class Kanji(
    @Id
    val id: String? = null,
    val character: String,
    val meaning: String,
    val meaningEn: String? = null,
    val onyomi: List<String> = emptyList(), // Âm Hán
    val kunyomi: List<String> = emptyList(), // Âm Kun
    val radicals: List<String> = emptyList(),
    val strokeCount: Int,
    val jlptLevel: Int, // 1-5
    val frequency: Int? = null, // Tần suất sử dụng
    val compounds: List<KanjiCompound> = emptyList(),
    val examples: List<KanjiExample> = emptyList(),
    val strokeOrder: List<String> = emptyList(), // URLs for stroke order images
    val mnemonics: String? = null, // Ghi nhớ
    val tags: List<String> = emptyList(),
    val createdAt: Long = System.currentTimeMillis()
)

data class KanjiCompound(
    val word: String,
    val reading: String,
    val meaning: String,
    val meaningEn: String? = null
)

data class KanjiExample(
    val sentence: String,
    val reading: String? = null,
    val meaning: String,
    val meaningEn: String? = null
)
