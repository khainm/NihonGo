package com.nihongo.backend.domain.model

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document
import java.time.Duration
import java.time.LocalDateTime

@Document(collection = "learning_lessons")
data class LearningLesson(
    @Id
    val id: String? = null,
    val title: String,
    val description: String,
    val type: LessonType, // VOCABULARY, GRAMMAR, KANJI, LISTENING
    val jlptLevel: Int,
    val category: String? = null,
    val totalItems: Int,
    val estimatedTimeMinutes: Int,
    val difficulty: LessonDifficulty = LessonDifficulty.BEGINNER,
    val tags: List<String> = emptyList(),
    val prerequisites: List<String> = emptyList(), // IDs of prerequisite lessons
    val itemIds: List<String> = emptyList(), // IDs of vocabulary/grammar/kanji/listening items
    val isActive: Boolean = true,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val updatedAt: LocalDateTime = LocalDateTime.now()
)

enum class LessonType {
    VOCABULARY,
    GRAMMAR,
    KANJI,
    LISTENING
}

enum class LessonDifficulty {
    BEGINNER,
    INTERMEDIATE,
    ADVANCED
}

@Document(collection = "user_lesson_progress")
data class UserLessonProgress(
    @Id
    val id: String? = null,
    val userId: String,
    val lessonId: String,
    val completedItems: Int = 0,
    val learnedItemIds: Set<String> = emptySet(),
    val isCompleted: Boolean = false,
    val progressPercentage: Double = 0.0,
    val startedAt: LocalDateTime = LocalDateTime.now(),
    val lastAccessedAt: LocalDateTime = LocalDateTime.now(),
    val completedAt: LocalDateTime? = null
)
