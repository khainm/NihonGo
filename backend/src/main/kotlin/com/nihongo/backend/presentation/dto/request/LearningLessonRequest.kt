package com.nihongo.backend.presentation.dto.request

data class UpdateLessonProgressRequest(
    val lessonId: String,
    val itemId: String,
    val isLearned: Boolean
)

data class CreateLearningLessonRequest(
    val title: String,
    val description: String,
    val type: String, // VOCABULARY, GRAMMAR, KANJI, LISTENING
    val jlptLevel: Int,
    val category: String?,
    val estimatedTimeMinutes: Int,
    val difficulty: String, // BEGINNER, INTERMEDIATE, ADVANCED
    val tags: List<String> = emptyList(),
    val prerequisites: List<String> = emptyList(),
    val itemIds: List<String> = emptyList()
)
