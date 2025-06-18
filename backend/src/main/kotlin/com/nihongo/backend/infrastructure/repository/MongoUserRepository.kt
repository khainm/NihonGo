package com.nihongo.backend.infrastructure.repository

import com.nihongo.backend.domain.model.User
import org.springframework.data.mongodb.repository.MongoRepository

interface MongoUserRepository : MongoRepository<User, String> {
    fun findByEmail(email: String): User?
} 