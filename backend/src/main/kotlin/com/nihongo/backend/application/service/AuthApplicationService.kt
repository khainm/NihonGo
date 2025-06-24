package com.nihongo.backend.application.service

import com.nihongo.backend.application.usecase.LoginUserUseCase
import com.nihongo.backend.application.usecase.RegisterUserUseCase
import com.nihongo.backend.domain.model.User
import com.nihongo.backend.infrastructure.config.JwtService
import org.springframework.stereotype.Service

@Service
class AuthApplicationService(
    private val registerUserUseCase: RegisterUserUseCase,
    private val loginUserUseCase: LoginUserUseCase,
    private val jwtService: JwtService
) {
    
    fun register(name: String?, email: String, password: String): AuthResponse {
        val user = registerUserUseCase.execute(name, email, password)
        val token = jwtService.generateToken(user.email)
        return AuthResponse(user, token)
    }
    
    fun login(email: String, password: String): AuthResponse {
        val user = loginUserUseCase.execute(email, password)
        val token = jwtService.generateToken(user.email)
        return AuthResponse(user, token)
    }
}

data class AuthResponse(
    val user: User,
    val token: String
)
