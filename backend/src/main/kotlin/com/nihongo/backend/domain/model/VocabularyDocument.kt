package com.nihongo.backend.domain.model

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document

@Document(collection = "JlptVocabulary")
data class VocabularyDocument(
    @Id
    val id: String? = null,
    val lesson: String,
    val vocabulary: List<VocabularyItem>
)

data class VocabularyItem(
    val japanese: String,
    val vietnamese: String
)
