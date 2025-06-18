package com.nihongo.backend.infrastructure.repository

import com.nihongo.backend.domain.model.User
import com.nihongo.backend.domain.repository.UserRepository
import org.springframework.stereotype.Repository

@Repository
class UserRepositoryImpl(
    private val mongoUserRepository: MongoUserRepository
) : UserRepository {
    override fun findByEmail(email: String): User? = mongoUserRepository.findByEmail(email)
    override fun save(user: User): User = mongoUserRepository.save(user)
} 