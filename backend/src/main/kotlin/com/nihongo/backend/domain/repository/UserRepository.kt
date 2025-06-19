package com.nihongo.backend.domain.repository

import com.nihongo.backend.domain.model.User

interface UserRepository {
    fun findByEmail(email: String): User?
    fun save(user: User): User
} 