package com.nihongo.backend.infrastructure.repository

import com.nihongo.backend.domain.model.JlptVocabularyLesson
import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.stereotype.Repository

@Repository
interface JlptVocabularyLessonRepository : MongoRepository<JlptVocabularyLesson, String> {
    fun findByLessonId(lessonId: String): JlptVocabularyLesson?
    fun findByJlptLevelOrderByLessonNumberAsc(jlptLevel: String): List<JlptVocabularyLesson>
    fun findByJlptLevelAndLessonNumber(jlptLevel: String, lessonNumber: Int): JlptVocabularyLesson?
    fun findAllByOrderByJlptLevelDescLessonNumberAsc(): List<JlptVocabularyLesson>
}
