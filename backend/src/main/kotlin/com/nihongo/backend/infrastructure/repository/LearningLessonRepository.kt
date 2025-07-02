package com.nihongo.backend.infrastructure.repository

import com.nihongo.backend.domain.model.LearningLesson
import com.nihongo.backend.domain.model.LessonType
import com.nihongo.backend.domain.model.UserLessonProgress
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.data.mongodb.repository.Query
import org.springframework.stereotype.Repository

@Repository
interface LearningLessonRepository : MongoRepository<LearningLesson, String> {
    
    fun findByJlptLevelAndTypeAndIsActive(
        jlptLevel: Int, 
        type: LessonType, 
        isActive: Boolean, 
        pageable: Pageable
    ): Page<LearningLesson>
    
    fun findByTypeAndIsActive(type: LessonType, isActive: Boolean, pageable: Pageable): Page<LearningLesson>
    
    fun findByJlptLevelAndIsActive(jlptLevel: Int, isActive: Boolean, pageable: Pageable): Page<LearningLesson>
    
    @Query("{ 'title': { \$regex: ?0, \$options: 'i' }, 'isActive': true }")
    fun searchByTitleAndIsActive(keyword: String, pageable: Pageable): Page<LearningLesson>
    
    fun findByCategoryAndIsActive(category: String, isActive: Boolean, pageable: Pageable): Page<LearningLesson>
    
    fun findByTagsInAndIsActive(tags: List<String>, isActive: Boolean, pageable: Pageable): Page<LearningLesson>
}

@Repository
interface UserLessonProgressRepository : MongoRepository<UserLessonProgress, String> {
    
    fun findByUserIdAndLessonId(userId: String, lessonId: String): UserLessonProgress?
    
    fun findByUserId(userId: String, pageable: Pageable): Page<UserLessonProgress>
    
    fun findByUserIdAndIsCompleted(userId: String, isCompleted: Boolean, pageable: Pageable): Page<UserLessonProgress>
    
    fun countByUserIdAndIsCompleted(userId: String, isCompleted: Boolean): Long
}
