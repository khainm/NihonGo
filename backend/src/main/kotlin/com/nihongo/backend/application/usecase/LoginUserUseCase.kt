package com.nihongo.backend.application.usecase

import com.nihongo.backend.domain.model.User
import com.nihongo.backend.domain.repository.UserRepository
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service

@Service
class LoginUserUseCase(
    private val userRepository: UserRepository,
    private val passwordEncoder: PasswordEncoder
) {
    fun execute(email: String, password: String): User {
        // Find user by email
        val user = userRepository.findByEmail(email)
            ?: throw IllegalArgumentException("Invalid email or password")
        
        // Verify password
        if (!passwordEncoder.matches(password, user.password)) {
            throw IllegalArgumentException("Invalid email or password")
        }
        
        return user
    }
}
