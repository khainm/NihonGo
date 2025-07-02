package com.nihongo.backend.infrastructure.repository

import com.nihongo.backend.domain.model.Kanji
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.data.mongodb.repository.Query
import org.springframework.stereotype.Repository

@Repository
interface KanjiRepository : MongoRepository<Kanji, String> {
    
    fun findByJlptLevel(jlptLevel: Int, pageable: Pageable): Page<Kanji>
    
    fun findByStrokeCountBetween(minStrokes: Int, maxStrokes: Int, pageable: Pageable): Page<Kanji>
    
    @Query("{ '\$or': [ { 'character': ?0 }, { 'meaning': { '\$regex': ?0, '\$options': 'i' } } ] }")
    fun searchByCharacterOrMeaning(keyword: String, pageable: Pageable): Page<Kanji>
    
    fun findByRadicalsContaining(radical: String, pageable: Pageable): Page<Kanji>
    
    fun findByTagsContaining(tag: String, pageable: Pageable): Page<Kanji>
    
    fun findByOrderByFrequencyAsc(pageable: Pageable): Page<Kanji>
}
