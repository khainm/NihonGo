package com.nihongo.backend.presentation.dto.response

data class JlptLevelResponse(
    val jlptLevel: String, // "N5", "N4", etc.
    val totalLessons: Int,
    val completedLessons: Int,
    val totalWords: Int,
    val completedWords: Int,
    val progressPercentage: Int,
    val isUnlocked: Boolean = true
)

data class JlptLessonResponse(
    val lessonId: String, // "n5_bai_1"
    val jlptLevel: String, // "N5"
    val lessonNumber: Int, // 1
    val title: String,
    val totalWords: Int,
    val completedWords: Int,
    val isCompleted: Boolean,
    val progressPercentage: Int,
    val vocabulary: List<JlptVocabularyResponse>? = null
)

data class JlptVocabularyResponse(
    val id: String,
    val japanese: String,
    val vietnamese: String,
    val reading: String? = null,
    val notes: String? = null,
    val difficulty: Int = 1,
    val category: String? = null,
    val isLearned: Boolean = false
)
