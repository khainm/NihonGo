package com.nihongo.backend.application.service

import com.nihongo.backend.application.usecase.LoginUserUseCase
import com.nihongo.backend.application.usecase.RegisterUserUseCase
import com.nihongo.backend.domain.model.User
import org.springframework.stereotype.Service

@Service
class AuthApplicationService(
    private val registerUserUseCase: RegisterUserUseCase,
    private val loginUserUseCase: LoginUserUseCase
) {
    
    fun register(name: String?, email: String, password: String): User {
        return registerUserUseCase.execute(name, email, password)
    }
    
    fun login(email: String, password: String): User {
        return loginUserUseCase.execute(email, password)
    }
}
