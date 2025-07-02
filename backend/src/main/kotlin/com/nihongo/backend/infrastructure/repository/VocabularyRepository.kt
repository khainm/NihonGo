package com.nihongo.backend.infrastructure.repository

import com.nihongo.backend.domain.model.Vocabulary
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.data.mongodb.repository.Query
import org.springframework.stereotype.Repository

@Repository
interface VocabularyRepository : MongoRepository<Vocabulary, String> {
    
    fun findByJlptLevel(jlptLevel: Int, pageable: Pageable): Page<Vocabulary>
    
    fun findByCategory(category: String, pageable: Pageable): Page<Vocabulary>
    
    fun findByJlptLevelAndCategory(jlptLevel: Int, category: String, pageable: Pageable): Page<Vocabulary>
    
    @Query("{ '\$or': [ { 'word': { '\$regex': ?0, '\$options': 'i' } }, { 'meaning': { '\$regex': ?0, '\$options': 'i' } }, { 'romanji': { '\$regex': ?0, '\$options': 'i' } } ] }")
    fun searchByKeyword(keyword: String, pageable: Pageable): Page<Vocabulary>
    
    fun findByTagsContaining(tag: String, pageable: Pageable): Page<Vocabulary>
}
