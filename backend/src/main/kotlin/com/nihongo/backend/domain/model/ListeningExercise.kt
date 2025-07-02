package com.nihongo.backend.domain.model

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document

@Document(collection = "listening_exercises")
data class ListeningExercise(
    @Id
    val id: String? = null,
    val title: String,
    val description: String,
    val audioUrl: String,
    val transcript: String,
    val transcriptHiragana: String? = null,
    val translation: String,
    val jlptLevel: Int, // 1-5
    val duration: Int, // in seconds
    val difficulty: ListeningDifficulty,
    val category: String,
    val questions: List<ListeningQuestion> = emptyList(),
    val vocabulary: List<String> = emptyList(), // Related vocabulary IDs
    val tags: List<String> = emptyList(),
    val createdAt: Long = System.currentTimeMillis()
)

data class ListeningQuestion(
    val question: String,
    val options: List<String>,
    val correctAnswer: Int, // Index of correct option
    val explanation: String? = null,
    val timestamp: Int? = null // When in audio this relates to
)

enum class ListeningDifficulty {
    BEGINNER, INTERMEDIATE, ADVANCED
}
