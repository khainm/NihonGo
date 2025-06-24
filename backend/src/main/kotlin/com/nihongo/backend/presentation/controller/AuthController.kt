package com.nihongo.backend.presentation.controller

import com.nihongo.backend.application.service.AuthApplicationService
import com.nihongo.backend.presentation.dto.LoginRequest
import com.nihongo.backend.presentation.dto.RegisterRequest
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/auth")
class AuthController(
    private val authApplicationService: AuthApplicationService
) {
    @PostMapping("/register")
    fun register(@RequestBody request: RegisterRequest): ResponseEntity<Any> {
        return try {
            val response = authApplicationService.register(
                name = request.name,
                email = request.email,
                password = request.password
            )
            ResponseEntity.ok(response)
        } catch (e: IllegalArgumentException) {
            ResponseEntity.badRequest().body(mapOf("error" to e.message))
        }
    }

    @PostMapping("/login")
    fun login(@RequestBody request: LoginRequest): ResponseEntity<Any> {
        return try {
            val response = authApplicationService.login(
                email = request.email,
                password = request.password
            )
            ResponseEntity.ok(response)
        } catch (e: IllegalArgumentException) {
            ResponseEntity.badRequest().body(mapOf("error" to e.message))
        }
    }
} 