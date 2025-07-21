package com.nihongo.backend.infrastructure.repository

import com.nihongo.backend.domain.model.VocabularyDocument
import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.data.mongodb.repository.Query
import org.springframework.stereotype.Repository

@Repository
interface VocabularyRepository : MongoRepository<VocabularyDocument, String> {
    
    @Query("{'lesson': ?0}")
    fun findByLesson(lesson: String): VocabularyDocument?
    
    @Query("{'lesson': {'\$regex': ?0, '\$options': 'i'}}")
    fun findByLessonContaining(lesson: String): List<VocabularyDocument>
}
