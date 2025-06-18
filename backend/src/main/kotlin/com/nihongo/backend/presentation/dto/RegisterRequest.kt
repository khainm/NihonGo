package com.nihongo.backend.presentation.dto

data class RegisterRequest(
    val name: String?,
    val email: String,
    val password: String
)
