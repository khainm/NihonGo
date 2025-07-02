package com.nihongo.backend.presentation.dto.response

import com.nihongo.backend.domain.model.LessonDifficulty
import com.nihongo.backend.domain.model.LessonType
import java.time.LocalDateTime

data class LearningLessonResponse(
    val id: String,
    val title: String,
    val description: String,
    val type: String,
    val jlptLevel: Int,
    val category: String?,
    val totalItems: Int,
    val estimatedTimeMinutes: Int,
    val difficulty: String,
    val tags: List<String>,
    val prerequisites: List<String>,
    val isActive: Boolean,
    val progress: LessonProgressResponse? = null
)

data class LessonProgressResponse(
    val id: String,
    val completedItems: Int,
    val totalItems: Int,
    val progressPercentage: Double,
    val isCompleted: Boolean,
    val startedAt: LocalDateTime,
    val lastAccessedAt: LocalDateTime,
    val completedAt: LocalDateTime?
)

data class VocabularyLessonDetailResponse(
    val lesson: LearningLessonResponse,
    val words: List<VocabularyResponse>
)

data class GrammarLessonDetailResponse(
    val lesson: LearningLessonResponse,
    val grammarPoints: List<GrammarResponse>
)

data class KanjiLessonDetailResponse(
    val lesson: LearningLessonResponse,
    val kanjiList: List<KanjiResponse>
)

data class ListeningLessonDetailResponse(
    val lesson: LearningLessonResponse,
    val exercises: List<ListeningExerciseResponse>
)

data class UserProgressSummaryResponse(
    val totalLessons: Int,
    val completedLessons: Int,
    val inProgressLessons: Int,
    val totalItemsLearned: Int,
    val progressByType: Map<String, TypeProgressResponse>,
    val progressByLevel: Map<Int, LevelProgressResponse>,
    val recentActivity: List<RecentActivityResponse>
)

data class TypeProgressResponse(
    val type: String,
    val totalLessons: Int,
    val completedLessons: Int,
    val progressPercentage: Double
)

data class LevelProgressResponse(
    val level: Int,
    val totalLessons: Int,
    val completedLessons: Int,
    val progressPercentage: Double
)

data class RecentActivityResponse(
    val lessonId: String,
    val lessonTitle: String,
    val lessonType: String,
    val lastAccessedAt: LocalDateTime,
    val progressPercentage: Double
)
