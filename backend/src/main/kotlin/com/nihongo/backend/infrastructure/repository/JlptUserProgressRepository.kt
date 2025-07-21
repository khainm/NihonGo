package com.nihongo.backend.infrastructure.repository

import com.nihongo.backend.domain.model.JlptUserProgress
import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.stereotype.Repository

@Repository
interface JlptUserProgressRepository : MongoRepository<JlptUserProgress, String> {
    fun findByUserIdAndLessonId(userId: String, lessonId: String): JlptUserProgress?
    fun findByUserId(userId: String): List<JlptUserProgress>
    fun findByUserIdAndJlptLevel(userId: String, jlptLevel: String): List<JlptUserProgress>
    fun findByUserIdAndJlptLevelAndLessonId(userId: String, jlptLevel: String, lessonId: String): List<JlptUserProgress>
    fun findByUserIdAndWordId(userId: String, wordId: String): JlptUserProgress?
    fun deleteByUserIdAndLessonId(userId: String, lessonId: String)
    fun deleteByUserIdAndJlptLevel(userId: String, jlptLevel: String)
}
