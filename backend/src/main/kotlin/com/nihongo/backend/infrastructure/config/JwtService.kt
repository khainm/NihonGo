package com.nihongo.backend.infrastructure.config

import io.jsonwebtoken.Claims
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.SignatureAlgorithm
import io.jsonwebtoken.security.Keys
import org.springframework.stereotype.Service
import java.util.*

@Service
class JwtService {
    private val secretKey = Keys.secretKeyFor(SignatureAlgorithm.HS256)
    private val tokenValidity = 30L * 24 * 60 * 60 * 1000 // 30 days

    fun generateToken(email: String): String {
        return Jwts.builder()
            .setSubject(email)
            .setIssuedAt(Date())
            .setExpiration(Date(System.currentTimeMillis() + tokenValidity))
            .signWith(secretKey)
            .compact()
    }

    fun validateToken(token: String): Boolean {
        return try {
            !isTokenExpired(token)
        } catch (e: Exception) {
            false
        }
    }

    fun getEmailFromToken(token: String): String? {
        return try {
            getClaimsFromToken(token).subject
        } catch (e: Exception) {
            null
        }
    }

    private fun isTokenExpired(token: String): Boolean {
        val expiration = getClaimsFromToken(token).expiration
        return expiration.before(Date())
    }

    private fun getClaimsFromToken(token: String): Claims {
        return Jwts.parserBuilder()
            .setSigningKey(secretKey)
            .build()
            .parseClaimsJws(token)
            .body
    }
} 