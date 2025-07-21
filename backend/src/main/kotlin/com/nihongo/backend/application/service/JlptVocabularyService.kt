package com.nihongo.backend.application.service

import com.nihongo.backend.domain.model.*
import com.nihongo.backend.infrastructure.repository.JlptVocabularyLessonRepository
import com.nihongo.backend.infrastructure.repository.JlptUserProgressRepository
import com.nihongo.backend.infrastructure.repository.VocabularyRepository
import com.nihongo.backend.presentation.dto.response.JlptLevelResponse
import com.nihongo.backend.presentation.dto.response.JlptLessonResponse
import com.nihongo.backend.presentation.dto.response.JlptVocabularyResponse
import org.springframework.stereotype.Service
import org.springframework.cache.annotation.Cacheable
import java.time.LocalDateTime

@Service
class JlptVocabularyService(
    private val jlptLessonRepository: JlptVocabularyLessonRepository,
    private val jlptProgressRepository: JlptUserProgressRepository,
    private val vocabularyRepository: VocabularyRepository
) {

    /**
     * Lấy danh sách các level JLPT có sẵn
     */
    @Cacheable("jlptLevels")
    fun getAvailableLevels(userId: String?): List<JlptLevelResponse> {
        val levels = listOf("N5", "N4", "N3", "N2", "N1")
        
        return levels.map { level ->
            val vocabularyDocs = vocabularyRepository.findAll()
            val progress = userId?.let { 
                jlptProgressRepository.findByUserIdAndJlptLevel(it, level)
            } ?: emptyList()
            
            val totalLessons = vocabularyDocs.size
            val totalWords = vocabularyDocs.sumOf { it.vocabulary.size }
            val completedWords = progress.count { it.isLearned }
            val completedLessons = vocabularyDocs.mapIndexed { index, doc ->
                val lessonId = "bai_${index + 1}"
                val lessonProgress = progress.filter { it.lessonId == lessonId }
                lessonProgress.isNotEmpty() && 
                lessonProgress.size == doc.vocabulary.size &&
                lessonProgress.all { it.isLearned }
            }.count { it }
            
            JlptLevelResponse(
                jlptLevel = level,
                totalLessons = totalLessons,
                completedLessons = completedLessons,
                totalWords = totalWords,
                completedWords = completedWords,
                progressPercentage = if (totalWords > 0) completedWords * 100 / totalWords else 0,
                isUnlocked = level == "N5" || completedLessons > 0
            )
        }
    }

    /**
     * Lấy danh sách bài học theo level (N5, N4, etc.) từ MongoDB
     */
    fun getLessonsByLevel(jlptLevel: String, userId: String?): List<JlptLessonResponse> {
        // Lấy tất cả vocabulary documents từ MongoDB
        val vocabularyDocs = vocabularyRepository.findAll()
        
        return vocabularyDocs.mapIndexed { index, doc ->
            val lessonId = "bai_${index + 1}"
            val progress = userId?.let { 
                jlptProgressRepository.findByUserIdAndJlptLevelAndLessonId(it, jlptLevel, lessonId)
            } ?: emptyList()
            
            val learnedWords = progress.count { it.isLearned }
            val totalWords = doc.vocabulary.size
            
            // Tạo vocabulary data với progress
            val vocabularyWithProgress = doc.vocabulary.mapIndexed { vocabIndex, word ->
                val wordId = "bai_${index + 1}_$vocabIndex"
                val wordProgress = progress.find { it.wordId == wordId }
                JlptVocabularyResponse(
                    id = wordId,
                    japanese = word.japanese,
                    vietnamese = word.vietnamese,
                    reading = word.japanese, // Sử dụng japanese làm reading
                    notes = "", // Để trống vì không có example
                    difficulty = 1,
                    category = "Từ vựng cơ bản",
                    isLearned = wordProgress?.isLearned ?: false
                )
            }
            
            JlptLessonResponse(
                lessonId = lessonId,
                jlptLevel = jlptLevel,
                lessonNumber = index + 1,
                title = doc.lesson,
                totalWords = totalWords,
                completedWords = learnedWords,
                isCompleted = learnedWords == totalWords && totalWords > 0,
                progressPercentage = if (totalWords > 0) learnedWords * 100 / totalWords else 0,
                vocabulary = vocabularyWithProgress
            )
        }
    }

    /**
     * Lấy chi tiết một bài học từ MongoDB
     */
    fun getLesson(jlptLevel: String, lessonNumber: Int, userId: String?): JlptLessonResponse? {
        // Lấy vocabulary từ MongoDB
        val vocabularyDocs = vocabularyRepository.findAll()
        val vocabularyDoc = vocabularyDocs.getOrNull(lessonNumber - 1) ?: return null
        
        val lessonId = "bai_$lessonNumber"
        
        println("DEBUG JlptVocabularyService.getLesson: userId=$userId, jlptLevel=$jlptLevel, lessonId=$lessonId")
        
        val progress = userId?.let { 
            val progressData = jlptProgressRepository.findByUserIdAndJlptLevelAndLessonId(it, jlptLevel, lessonId)
            println("DEBUG JlptVocabularyService.getLesson: Found ${progressData.size} progress entries")
            progressData.forEach { prog ->
                println("DEBUG JlptVocabularyService.getLesson: Progress - wordId=${prog.wordId}, isLearned=${prog.isLearned}")
            }
            progressData
        } ?: emptyList()
        
        val vocabularyWithProgress = vocabularyDoc.vocabulary.mapIndexed { index, word ->
            val wordId = "bai_${lessonNumber}_$index"
            val wordProgress = progress.find { it.wordId == wordId }
            println("DEBUG JlptVocabularyService.getLesson: Word $wordId -> isLearned=${wordProgress?.isLearned ?: false}")
            JlptVocabularyResponse(
                id = wordId,
                japanese = word.japanese,
                vietnamese = word.vietnamese,
                reading = word.japanese, // Sử dụng japanese làm reading vì không có hiragana riêng
                notes = "", // Để trống vì không có example
                difficulty = 1,
                category = "Từ vựng cơ bản",
                isLearned = wordProgress?.isLearned ?: false
            )
        }
        
        val learnedWords = vocabularyWithProgress.count { it.isLearned }
        println("DEBUG JlptVocabularyService.getLesson: Total words=${vocabularyDoc.vocabulary.size}, learned words=$learnedWords")
        
        return JlptLessonResponse(
            lessonId = lessonId,
            jlptLevel = jlptLevel,
            lessonNumber = lessonNumber,
            title = vocabularyDoc.lesson,
            totalWords = vocabularyDoc.vocabulary.size,
            completedWords = learnedWords,
            isCompleted = learnedWords == vocabularyDoc.vocabulary.size && vocabularyDoc.vocabulary.isNotEmpty(),
            progressPercentage = if (vocabularyDoc.vocabulary.isNotEmpty()) 
                learnedWords * 100 / vocabularyDoc.vocabulary.size else 0,
            vocabulary = vocabularyWithProgress
        )
    }

    /**
     * Cập nhật tiến độ học từ
     */
    fun updateWordProgress(userId: String, jlptLevel: String, lessonId: String, wordId: String, isLearned: Boolean) {
        val existingProgress = jlptProgressRepository.findByUserIdAndWordId(userId, wordId)
        
        if (existingProgress != null) {
            jlptProgressRepository.save(
                existingProgress.copy(
                    isLearned = isLearned,
                    practiceCount = existingProgress.practiceCount + 1,
                    correctCount = if (isLearned) existingProgress.correctCount + 1 else existingProgress.correctCount,
                    lastPracticed = LocalDateTime.now(),
                    updatedAt = LocalDateTime.now()
                )
            )
        } else {
            jlptProgressRepository.save(
                JlptUserProgress(
                    userId = userId,
                    jlptLevel = jlptLevel,
                    lessonId = lessonId,
                    wordId = wordId,
                    isLearned = isLearned,
                    practiceCount = 1,
                    correctCount = if (isLearned) 1 else 0,
                    lastPracticed = LocalDateTime.now()
                )
            )
        }
    }

    /**
     * Cập nhật tiến độ học từ với auto-derive level và lesson từ wordId
     */
    fun updateWordProgress(userId: String, wordId: String, isLearned: Boolean) {
        val (jlptLevel, lessonId) = deriveLevelAndLessonFromWordId(wordId)
        updateWordProgress(userId, jlptLevel, lessonId, wordId, isLearned)
    }

    /**
     * Derive JLPT level và lesson ID từ wordId
     * Example: "bai_1_0" -> ("N5", "bai_1")
     */
    private fun deriveLevelAndLessonFromWordId(wordId: String): Pair<String, String> {
        val parts = wordId.split("_")
        if (parts.size >= 3) {
            val lessonNumber = parts[1].toIntOrNull()
            val level = when {
                lessonNumber != null && lessonNumber <= 25 -> "N5" // Assume N5 for bai_1 to bai_25
                else -> "N5" // Default to N5
            }
            val lesson = "${parts[0]}_${parts[1]}" // "bai_1"
            return Pair(level, lesson)
        }
        throw IllegalArgumentException("Invalid wordId format: $wordId")
    }

    /**
     * Lấy thống kê theo level từ MongoDB
     */
    fun getLevelStats(userId: String, jlptLevel: String): Map<String, Any> {
        val vocabularyDocs = vocabularyRepository.findAll()
        val progress = jlptProgressRepository.findByUserIdAndJlptLevel(userId, jlptLevel)
        
        val totalLessons = vocabularyDocs.size
        val totalWords = vocabularyDocs.sumOf { it.vocabulary.size }
        val completedWords = progress.count { it.isLearned }
        val completedLessons = vocabularyDocs.mapIndexed { index, doc ->
            val lessonId = "bai_${index + 1}"
            val lessonProgress = progress.filter { it.lessonId == lessonId }
            lessonProgress.isNotEmpty() && 
            lessonProgress.size == doc.vocabulary.size &&
            lessonProgress.all { it.isLearned }
        }.count { it }
        
        return mapOf(
            "jlptLevel" to jlptLevel,
            "totalLessons" to totalLessons,
            "completedLessons" to completedLessons,
            "totalWords" to totalWords,
            "completedWords" to completedWords,
            "levelProgress" to if (totalWords > 0) completedWords.toDouble() / totalWords else 0.0
        )
    }

    /**
     * Lấy thống kê tổng quan tất cả levels
     */
    fun getOverallStats(userId: String): Map<String, Any> {
        val levelStats = listOf("N5", "N4", "N3", "N2", "N1").map { level ->
            getLevelStats(userId, level)
        }
        
        val totalWords = levelStats.sumOf { it["totalWords"] as Int }
        val completedWords = levelStats.sumOf { it["completedWords"] as Int }
        val totalLessons = levelStats.sumOf { it["totalLessons"] as Int }
        val completedLessons = levelStats.sumOf { it["completedLessons"] as Int }
        
        return mapOf(
            "totalLevels" to 5,
            "totalLessons" to totalLessons,
            "completedLessons" to completedLessons,
            "totalWords" to totalWords,
            "completedWords" to completedWords,
            "overallProgress" to if (totalWords > 0) completedWords.toDouble() / totalWords else 0.0,
            "levelStats" to levelStats
        )
    }

    /**
     * Reset tiến độ một bài học
     */
    fun resetLessonProgress(userId: String, jlptLevel: String, lessonNumber: Int) {
        val lessonId = "bai_$lessonNumber"
        jlptProgressRepository.findByUserIdAndJlptLevelAndLessonId(userId, jlptLevel, lessonId)
            .forEach { jlptProgressRepository.delete(it) }
    }

    /**
     * Reset toàn bộ tiến độ một level
     */
    fun resetLevelProgress(userId: String, jlptLevel: String) {
        jlptProgressRepository.findByUserIdAndJlptLevel(userId, jlptLevel)
            .forEach { jlptProgressRepository.delete(it) }
    }
}
