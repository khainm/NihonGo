package com.nihongo.backend.domain.model

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document

@Document(collection = "users")
data class User(
    @Id val id: String? = null,
    val name: String?,
    val email: String,
    val password: String // hashed password
) 