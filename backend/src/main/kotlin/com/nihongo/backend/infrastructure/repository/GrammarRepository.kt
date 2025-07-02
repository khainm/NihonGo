package com.nihongo.backend.infrastructure.repository

import com.nihongo.backend.domain.model.GrammarPoint
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.data.mongodb.repository.Query
import org.springframework.stereotype.Repository

@Repository
interface GrammarRepository : MongoRepository<GrammarPoint, String> {
    
    fun findByJlptLevel(jlptLevel: Int, pageable: Pageable): Page<GrammarPoint>
    
    @Query("{ '\$or': [ { 'title': { '\$regex': ?0, '\$options': 'i' } }, { 'meaning': { '\$regex': ?0, '\$options': 'i' } }, { 'structure': { '\$regex': ?0, '\$options': 'i' } } ] }")
    fun searchByKeyword(keyword: String, pageable: Pageable): Page<GrammarPoint>
    
    fun findByTagsContaining(tag: String, pageable: Pageable): Page<GrammarPoint>
}
