package com.nihongo.backend.infrastructure.repository

import com.nihongo.backend.domain.model.ListeningExercise
import com.nihongo.backend.domain.model.ListeningDifficulty
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.data.mongodb.repository.Query
import org.springframework.stereotype.Repository

@Repository
interface ListeningExerciseRepository : MongoRepository<ListeningExercise, String> {
    
    fun findByJlptLevel(jlptLevel: Int, pageable: Pageable): Page<ListeningExercise>
    
    fun findByDifficulty(difficulty: ListeningDifficulty, pageable: Pageable): Page<ListeningExercise>
    
    fun findByCategory(category: String, pageable: Pageable): Page<ListeningExercise>
    
    @Query("{ '\$or': [ { 'title': { '\$regex': ?0, '\$options': 'i' } }, { 'description': { '\$regex': ?0, '\$options': 'i' } } ] }")
    fun searchByKeyword(keyword: String, pageable: Pageable): Page<ListeningExercise>
    
    fun findByTagsContaining(tag: String, pageable: Pageable): Page<ListeningExercise>
}
