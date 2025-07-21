package com.nihongo.backend.domain.model

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document
import java.time.LocalDateTime

@Document(collection = "jlpt_user_progress")
data class JlptUserProgress(
    @Id
    val id: String? = null,
    val userId: String,
    val jlptLevel: String,
    val lessonId: String,
    val wordId: String,
    val isLearned: Boolean = false,
    val practiceCount: Int = 0,
    val correctCount: Int = 0,
    val lastPracticed: LocalDateTime? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val updatedAt: LocalDateTime = LocalDateTime.now()
)
