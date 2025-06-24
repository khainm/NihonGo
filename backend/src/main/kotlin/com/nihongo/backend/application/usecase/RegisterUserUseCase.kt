package com.nihongo.backend.application.usecase

import com.nihongo.backend.domain.model.User
import com.nihongo.backend.domain.repository.UserRepository
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service

@Service
class RegisterUserUseCase(
    private val userRepository: UserRepository,
    private val passwordEncoder: PasswordEncoder
) {
    fun execute(name: String?, email: String, password: String): User {
        // Check if email already exists
        userRepository.findByEmail(email)?.let {
            throw IllegalArgumentException("Email already exists")
        }
        
        // Create new user with hashed password
        val user = User(
            name = name,
            email = email,
            password = passwordEncoder.encode(password)
        )
        
        return userRepository.save(user)
    }
}
