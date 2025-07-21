package com.nihongo.backend.infrastructure.config

import io.jsonwebtoken.Claims
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.SignatureAlgorithm
import io.jsonwebtoken.security.Keys
import org.springframework.stereotype.Service
import java.util.*

@Service
class JwtService {
    // Use a fixed secret key to ensure tokens persist across restarts
    private val secretKey = Keys.hmacShaKeyFor("MySecretKeyForJWTTokenSigningThatIsVeryLongAndSecure1234567890".toByteArray())
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
            val claims = getClaimsFromToken(token)
            val email = claims.subject
            println("DEBUG JwtService.getEmailFromToken: Successfully extracted email = $email")
            email
        } catch (e: Exception) {
            println("DEBUG JwtService.getEmailFromToken: Error parsing token: ${e.message}")
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