package com.nihongo.backend.application.usecase

import com.nihongo.backend.domain.model.User
import com.nihongo.backend.domain.repository.UserRepository
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.stereotype.Service

@Service
class RegisterUserUseCase(
    private val userRepository: UserRepository
) {
    private val passwordEncoder = BCryptPasswordEncoder()

    fun execute(name: String?, email: String, password: String): User {
        // Validate business rules
        if (userRepository.findByEmail(email) != null) {
            throw IllegalArgumentException("Email already exists")
        }
        
        if (password.length < 8) {
            throw IllegalArgumentException("Password must be at least 8 characters")
        }
        
        // Hash password
        val hashedPassword = passwordEncoder.encode(password)
        
        // Create and save user
        val user = User(
            name = name,
            email = email,
            password = hashedPassword
        )
        
        return userRepository.save(user)
    }
}
