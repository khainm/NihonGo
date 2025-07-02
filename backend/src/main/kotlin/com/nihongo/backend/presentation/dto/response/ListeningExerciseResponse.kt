package com.nihongo.backend.presentation.dto.response

data class ListeningExerciseResponse(
    val id: String?,
    val title: String,
    val description: String,
    val audioUrl: String,
    val transcript: String,
    val transcriptHiragana: String?,
    val translation: String,
    val jlptLevel: Int,
    val duration: Int,
    val difficulty: String,
    val category: String,
    val questions: List<ListeningQuestionResponse>,
    val vocabulary: List<String>,
    val tags: List<String>
)

data class ListeningQuestionResponse(
    val question: String,
    val options: List<String>,
    val correctAnswer: Int,
    val explanation: String?,
    val timestamp: Int?
)
