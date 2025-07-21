package com.nihongo.backend.domain.model

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document

@Document(collection = "jlpt_vocabulary_lessons")
data class JlptVocabularyLesson(
    @Id
    val lessonId: String,
    val jlptLevel: String, // "N5", "N4", "N3", "N2", "N1"
    val lessonNumber: Int,
    val title: String,
    val vocabulary: List<JlptVocabularyWord>
)
