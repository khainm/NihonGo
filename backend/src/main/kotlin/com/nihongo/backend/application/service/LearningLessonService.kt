package com.nihongo.backend.application.service

import com.nihongo.backend.domain.model.*
import com.nihongo.backend.infrastructure.repository.*
import com.nihongo.backend.presentation.dto.request.UpdateLessonProgressRequest
import com.nihongo.backend.presentation.dto.response.*
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.cache.annotation.Cacheable
import java.time.LocalDateTime

@Service
class LearningLessonService(
    private val learningLessonRepository: LearningLessonRepository,
    private val userLessonProgressRepository: UserLessonProgressRepository,
    private val vocabularyRepository: VocabularyRepository,
    private val grammarRepository: GrammarRepository,
    private val kanjiRepository: KanjiRepository,
    private val listeningExerciseRepository: ListeningExerciseRepository,
    private val vocabularyService: VocabularyService,
    private val grammarService: GrammarService,
    private val kanjiService: KanjiService,
    private val listeningService: ListeningService
) {

    @Cacheable("learning-lessons")
    fun getLessonsByType(
        type: String, 
        jlptLevel: Int? = null, 
        page: Int = 0, 
        size: Int = 20,
        userId: String? = null
    ): PaginatedResponse<LearningLessonResponse> {
        val pageable = PageRequest.of(page, size, Sort.by("jlptLevel", "title"))
        val lessonType = LessonType.valueOf(type.uppercase())
        
        val lessonsPage = if (jlptLevel != null) {
            learningLessonRepository.findByJlptLevelAndTypeAndIsActive(jlptLevel, lessonType, true, pageable)
        } else {
            learningLessonRepository.findByTypeAndIsActive(lessonType, true, pageable)
        }
        
        // If no lessons exist, create sample lessons
        if (lessonsPage.isEmpty) {
            createSampleLessonsForType(lessonType, jlptLevel ?: 5)
            val newPage = if (jlptLevel != null) {
                learningLessonRepository.findByJlptLevelAndTypeAndIsActive(jlptLevel, lessonType, true, pageable)
            } else {
                learningLessonRepository.findByTypeAndIsActive(lessonType, true, pageable)
            }
            return createPaginatedResponse(newPage, userId)
        }
        
        return createPaginatedResponse(lessonsPage, userId)
    }

    fun getLessonDetail(lessonId: String, userId: String? = null): Any? {
        val lesson = learningLessonRepository.findById(lessonId).orElse(null) ?: return null
        val progress = userId?.let { userLessonProgressRepository.findByUserIdAndLessonId(it, lessonId) }
        
        return when (lesson.type) {
            LessonType.VOCABULARY -> {
                val words = getVocabularyItemsForLesson(lesson.itemIds)
                VocabularyLessonDetailResponse(
                    lesson = mapToLessonResponse(lesson, progress),
                    words = words
                )
            }
            LessonType.GRAMMAR -> {
                val grammarPoints = getGrammarItemsForLesson(lesson.itemIds)
                GrammarLessonDetailResponse(
                    lesson = mapToLessonResponse(lesson, progress),
                    grammarPoints = grammarPoints
                )
            }
            LessonType.KANJI -> {
                val kanjiList = getKanjiItemsForLesson(lesson.itemIds)
                KanjiLessonDetailResponse(
                    lesson = mapToLessonResponse(lesson, progress),
                    kanjiList = kanjiList
                )
            }
            LessonType.LISTENING -> {
                val exercises = getListeningItemsForLesson(lesson.itemIds)
                ListeningLessonDetailResponse(
                    lesson = mapToLessonResponse(lesson, progress),
                    exercises = exercises
                )
            }
        }
    }

    fun updateLessonProgress(userId: String, request: UpdateLessonProgressRequest): LessonProgressResponse? {
        val lesson = learningLessonRepository.findById(request.lessonId).orElse(null) ?: return null
        
        var progress = userLessonProgressRepository.findByUserIdAndLessonId(userId, request.lessonId)
            ?: UserLessonProgress(
                userId = userId,
                lessonId = request.lessonId
            )
        
        val updatedLearnedItems = if (request.isLearned) {
            progress.learnedItemIds + request.itemId
        } else {
            progress.learnedItemIds - request.itemId
        }
        
        val completedItems = updatedLearnedItems.size
        val progressPercentage = if (lesson.totalItems > 0) {
            (completedItems.toDouble() / lesson.totalItems) * 100
        } else 0.0
        
        progress = progress.copy(
            completedItems = completedItems,
            learnedItemIds = updatedLearnedItems,
            progressPercentage = progressPercentage,
            isCompleted = completedItems >= lesson.totalItems,
            lastAccessedAt = LocalDateTime.now(),
            completedAt = if (completedItems >= lesson.totalItems) LocalDateTime.now() else progress.completedAt
        )
        
        val savedProgress = userLessonProgressRepository.save(progress)
        return mapToProgressResponse(savedProgress, lesson.totalItems)
    }

    fun getUserProgressSummary(userId: String): UserProgressSummaryResponse {
        val allProgress = userLessonProgressRepository.findByUserId(userId, PageRequest.of(0, 1000))
        val completedCount = userLessonProgressRepository.countByUserIdAndIsCompleted(userId, true)
        val inProgressCount = allProgress.totalElements - completedCount
        
        val progressByType = mutableMapOf<String, TypeProgressResponse>()
        val progressByLevel = mutableMapOf<Int, LevelProgressResponse>()
        val recentActivity = mutableListOf<RecentActivityResponse>()
        
        // Calculate progress by type and level
        allProgress.content.forEach { progress ->
            val lesson = learningLessonRepository.findById(progress.lessonId).orElse(null)
            lesson?.let {
                // Progress by type
                val typeKey = it.type.name
                val currentTypeProgress = progressByType[typeKey] ?: TypeProgressResponse(typeKey, 0, 0, 0.0)
                progressByType[typeKey] = currentTypeProgress.copy(
                    totalLessons = currentTypeProgress.totalLessons + 1,
                    completedLessons = currentTypeProgress.completedLessons + if (progress.isCompleted) 1 else 0
                )
                
                // Progress by level
                val currentLevelProgress = progressByLevel[it.jlptLevel] ?: LevelProgressResponse(it.jlptLevel, 0, 0, 0.0)
                progressByLevel[it.jlptLevel] = currentLevelProgress.copy(
                    totalLessons = currentLevelProgress.totalLessons + 1,
                    completedLessons = currentLevelProgress.completedLessons + if (progress.isCompleted) 1 else 0
                )
                
                // Recent activity
                recentActivity.add(
                    RecentActivityResponse(
                        lessonId = progress.lessonId,
                        lessonTitle = it.title,
                        lessonType = it.type.name,
                        lastAccessedAt = progress.lastAccessedAt,
                        progressPercentage = progress.progressPercentage
                    )
                )
            }
        }
        
        // Calculate percentages
        progressByType.forEach { (key, value) ->
            progressByType[key] = value.copy(
                progressPercentage = if (value.totalLessons > 0) {
                    (value.completedLessons.toDouble() / value.totalLessons) * 100
                } else 0.0
            )
        }
        
        progressByLevel.forEach { (key, value) ->
            progressByLevel[key] = value.copy(
                progressPercentage = if (value.totalLessons > 0) {
                    (value.completedLessons.toDouble() / value.totalLessons) * 100
                } else 0.0
            )
        }
        
        return UserProgressSummaryResponse(
            totalLessons = allProgress.content.size,
            completedLessons = completedCount.toInt(),
            inProgressLessons = inProgressCount.toInt(),
            totalItemsLearned = allProgress.content.sumOf { it.completedItems },
            progressByType = progressByType,
            progressByLevel = progressByLevel,
            recentActivity = recentActivity.sortedByDescending { it.lastAccessedAt }.take(10)
        )
    }

    fun searchLessons(keyword: String, page: Int = 0, size: Int = 20, userId: String? = null): PaginatedResponse<LearningLessonResponse> {
        val pageable = PageRequest.of(page, size, Sort.by("title"))
        val lessonsPage = learningLessonRepository.searchByTitleAndIsActive(keyword, pageable)
        return createPaginatedResponse(lessonsPage, userId)
    }

    private fun createSampleLessonsForType(type: LessonType, jlptLevel: Int) {
        val sampleLessons = when (type) {
            LessonType.VOCABULARY -> createSampleVocabularyLessons(jlptLevel)
            LessonType.GRAMMAR -> createSampleGrammarLessons(jlptLevel)
            LessonType.KANJI -> createSampleKanjiLessons(jlptLevel)
            LessonType.LISTENING -> createSampleListeningLessons(jlptLevel)
        }
        learningLessonRepository.saveAll(sampleLessons)
    }

    private fun createSampleVocabularyLessons(jlptLevel: Int): List<LearningLesson> {
        return listOf(
            LearningLesson(
                title = "Từ vựng cơ bản - Chào hỏi",
                description = "Học các từ vựng chào hỏi cơ bản trong tiếng Nhật",
                type = LessonType.VOCABULARY,
                jlptLevel = jlptLevel,
                category = "greeting",
                totalItems = 20,
                estimatedTimeMinutes = 30,
                difficulty = LessonDifficulty.BEGINNER,
                tags = listOf("greeting", "basic", "daily-conversation"),
                itemIds = emptyList() // Will be populated based on vocabulary data
            ),
            LearningLesson(
                title = "Từ vựng gia đình",
                description = "Học các từ vựng về thành viên trong gia đình",
                type = LessonType.VOCABULARY,
                jlptLevel = jlptLevel,
                category = "family",
                totalItems = 15,
                estimatedTimeMinutes = 25,
                difficulty = LessonDifficulty.BEGINNER,
                tags = listOf("family", "relationships", "basic"),
                itemIds = emptyList()
            )
        )
    }

    private fun createSampleGrammarLessons(jlptLevel: Int): List<LearningLesson> {
        return listOf(
            LearningLesson(
                title = "Ngữ pháp cơ bản - です/だ",
                description = "Học cách sử dụng です và だ",
                type = LessonType.GRAMMAR,
                jlptLevel = jlptLevel,
                category = "copula",
                totalItems = 5,
                estimatedTimeMinutes = 45,
                difficulty = LessonDifficulty.BEGINNER,
                tags = listOf("copula", "basic", "sentence-structure"),
                itemIds = emptyList()
            )
        )
    }

    private fun createSampleKanjiLessons(jlptLevel: Int): List<LearningLesson> {
        return listOf(
            LearningLesson(
                title = "Kanji cơ bản - Số đếm",
                description = "Học các chữ Kanji biểu thị số đếm",
                type = LessonType.KANJI,
                jlptLevel = jlptLevel,
                category = "numbers",
                totalItems = 10,
                estimatedTimeMinutes = 40,
                difficulty = LessonDifficulty.BEGINNER,
                tags = listOf("numbers", "basic", "counting"),
                itemIds = emptyList()
            )
        )
    }

    private fun createSampleListeningLessons(jlptLevel: Int): List<LearningLesson> {
        return listOf(
            LearningLesson(
                title = "Luyện nghe - Giới thiệu bản thân",
                description = "Luyện nghe các đoạn hội thoại giới thiệu bản thân",
                type = LessonType.LISTENING,
                jlptLevel = jlptLevel,
                category = "introduction",
                totalItems = 5,
                estimatedTimeMinutes = 60,
                difficulty = LessonDifficulty.BEGINNER,
                tags = listOf("introduction", "conversation", "self-introduction"),
                itemIds = emptyList()
            )
        )
    }

    private fun getVocabularyItemsForLesson(itemIds: List<String>): List<VocabularyResponse> {
        if (itemIds.isEmpty()) return emptyList()
        return itemIds.mapNotNull { vocabularyService.getVocabularyById(it) }
    }

    private fun getGrammarItemsForLesson(itemIds: List<String>): List<GrammarResponse> {
        if (itemIds.isEmpty()) return emptyList()
        return itemIds.mapNotNull { grammarService.getGrammarById(it) }
    }

    private fun getKanjiItemsForLesson(itemIds: List<String>): List<KanjiResponse> {
        if (itemIds.isEmpty()) return emptyList()
        return itemIds.mapNotNull { kanjiService.getKanjiById(it) }
    }

    private fun getListeningItemsForLesson(itemIds: List<String>): List<ListeningExerciseResponse> {
        if (itemIds.isEmpty()) return emptyList()
        return itemIds.mapNotNull { listeningService.getListeningExerciseById(it) }
    }

    private fun createPaginatedResponse(
        page: org.springframework.data.domain.Page<LearningLesson>,
        userId: String?
    ): PaginatedResponse<LearningLessonResponse> {
        val progressMap = userId?.let { uid ->
            userLessonProgressRepository.findByUserId(uid, PageRequest.of(0, 1000))
                .content.associateBy { it.lessonId }
        } ?: emptyMap()

        return PaginatedResponse(
            items = page.content.map { mapToLessonResponse(it, progressMap[it.id]) },
            totalItems = page.totalElements,
            currentPage = page.number,
            totalPages = page.totalPages,
            hasNext = page.hasNext(),
            hasPrevious = page.hasPrevious()
        )
    }

    private fun mapToLessonResponse(lesson: LearningLesson, progress: UserLessonProgress?): LearningLessonResponse {
        return LearningLessonResponse(
            id = lesson.id!!,
            title = lesson.title,
            description = lesson.description,
            type = lesson.type.name,
            jlptLevel = lesson.jlptLevel,
            category = lesson.category,
            totalItems = lesson.totalItems,
            estimatedTimeMinutes = lesson.estimatedTimeMinutes,
            difficulty = lesson.difficulty.name,
            tags = lesson.tags,
            prerequisites = lesson.prerequisites,
            isActive = lesson.isActive,
            progress = progress?.let { mapToProgressResponse(it, lesson.totalItems) }
        )
    }

    private fun mapToProgressResponse(progress: UserLessonProgress, totalItems: Int): LessonProgressResponse {
        return LessonProgressResponse(
            id = progress.id!!,
            completedItems = progress.completedItems,
            totalItems = totalItems,
            progressPercentage = progress.progressPercentage,
            isCompleted = progress.isCompleted,
            startedAt = progress.startedAt,
            lastAccessedAt = progress.lastAccessedAt,
            completedAt = progress.completedAt
        )
    }
}
