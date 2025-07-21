package com.nihongo.backend.presentation.controller

import com.nihongo.backend.application.service.JlptVocabularyService
import com.nihongo.backend.presentation.dto.response.ApiResponse
import com.nihongo.backend.presentation.dto.response.JlptLevelResponse
import com.nihongo.backend.presentation.dto.response.JlptLessonResponse
import com.nihongo.backend.presentation.dto.request.JlptProgressUpdateRequest
import com.nihongo.backend.infrastructure.config.JwtService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.security.core.userdetails.UserDetails
import jakarta.servlet.http.HttpServletRequest

@RestController
@RequestMapping("/api/learning/jlpt-vocabulary")
@CrossOrigin(origins = ["*"])
class JlptVocabularyController(
    private val jlptVocabularyService: JlptVocabularyService,
    private val jwtService: JwtService
) {

    private fun extractUserIdFromRequest(request: HttpServletRequest, userDetails: UserDetails?): String? {
        // First try to get userId from authenticated user
        userDetails?.username?.let { 
            println("DEBUG extractUserIdFromRequest: Using authenticated user: ${it}")
            return it 
        }
        
        // If not authenticated, try to extract from JWT token in header
        val authHeader = request.getHeader("Authorization")
        println("DEBUG extractUserIdFromRequest: Authorization header = $authHeader")
        
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            val token = authHeader.substring(7)
            println("DEBUG extractUserIdFromRequest: Extracted token = ${token.take(20)}...")
            return try {
                val email = jwtService.getEmailFromToken(token)
                println("DEBUG extractUserIdFromRequest: Extracted email from token = $email")
                email
            } catch (e: Exception) {
                println("DEBUG extractUserIdFromRequest: Error parsing token: ${e.message}")
                null
            }
        }
        println("DEBUG extractUserIdFromRequest: No valid auth found")
        return null
    }

    /**
     * Lấy danh sách tất cả levels JLPT với tiến độ
     */
    @GetMapping("/levels")
    fun getAllJlptLevels(
        @AuthenticationPrincipal userDetails: UserDetails?,
        request: HttpServletRequest
    ): ResponseEntity<ApiResponse<List<JlptLevelResponse>>> {
        return try {
            val userId = extractUserIdFromRequest(request, userDetails)
            val levels = jlptVocabularyService.getAvailableLevels(userId)
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = levels,
                    message = "JLPT levels retrieved successfully"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving JLPT levels: ${e.message}"
                )
            )
        }
    }

    /**
     * Lấy danh sách bài học theo level (N5, N4, etc.)
     */
    @GetMapping("/levels/{jlptLevel}/lessons")
    fun getLessonsByLevel(
        @PathVariable jlptLevel: String,
        @AuthenticationPrincipal userDetails: UserDetails?,
        request: HttpServletRequest
    ): ResponseEntity<ApiResponse<List<JlptLessonResponse>>> {
        return try {
            val userId = extractUserIdFromRequest(request, userDetails)
            val lessons = jlptVocabularyService.getLessonsByLevel(jlptLevel.uppercase(), userId)
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = lessons,
                    message = "$jlptLevel lessons retrieved successfully"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving $jlptLevel lessons: ${e.message}"
                )
            )
        }
    }

    /**
     * Lấy chi tiết một bài học
     */
    @GetMapping("/levels/{jlptLevel}/lessons/{lessonNumber}")
    fun getLesson(
        @PathVariable jlptLevel: String,
        @PathVariable lessonNumber: Int,
        @AuthenticationPrincipal userDetails: UserDetails?,
        request: HttpServletRequest
    ): ResponseEntity<ApiResponse<JlptLessonResponse>> {
        return try {
            val userId = extractUserIdFromRequest(request, userDetails)
            println("DEBUG getLesson: userId extracted = $userId")
            val lesson = jlptVocabularyService.getLesson(jlptLevel.uppercase(), lessonNumber, userId)
            if (lesson != null) {
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = lesson,
                        message = "Lesson retrieved successfully"
                    )
                )
            } else {
                ResponseEntity.notFound().build()
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving lesson: ${e.message}"
                )
            )
        }
    }

    /**
     * Cập nhật tiến độ học từ vựng
     */
    @PostMapping("/progress")
    fun updateProgress(
        @RequestBody request: JlptProgressUpdateRequest,
        @AuthenticationPrincipal userDetails: UserDetails?,
        httpRequest: HttpServletRequest
    ): ResponseEntity<ApiResponse<String>> {
        return try {
            // Get userId from authentication or manual extraction from JWT token
            val userId = userDetails?.username ?: extractUserIdFromRequest(httpRequest, userDetails)
            
            if (userId == null) {
                return ResponseEntity.badRequest().body(
                    ApiResponse(
                        success = false,
                        data = null,
                        message = "User ID is required"
                    )
                )
            }
            
            jlptVocabularyService.updateWordProgress(
                userId, 
                request.wordId, 
                request.isLearned
            )
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = "Progress updated successfully",
                    message = "Word progress updated"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error updating progress: ${e.message}"
                )
            )
        }
    }

    /**
     * Lấy thống kê theo level
     */
    @GetMapping("/levels/{jlptLevel}/stats")
    fun getLevelStats(
        @PathVariable jlptLevel: String,
        @AuthenticationPrincipal userDetails: UserDetails
    ): ResponseEntity<ApiResponse<Map<String, Any>>> {
        return try {
            val userId = userDetails.username
            val stats = jlptVocabularyService.getLevelStats(userId, jlptLevel.uppercase())
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = stats,
                    message = "$jlptLevel statistics retrieved successfully"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving $jlptLevel statistics: ${e.message}"
                )
            )
        }
    }

    /**
     * Lấy thống kê tổng quan tất cả levels
     */
    @GetMapping("/stats")
    fun getOverallStats(
        @AuthenticationPrincipal userDetails: UserDetails
    ): ResponseEntity<ApiResponse<Map<String, Any>>> {
        return try {
            val userId = userDetails.username
            val stats = jlptVocabularyService.getOverallStats(userId)
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = stats,
                    message = "Overall JLPT statistics retrieved successfully"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving overall statistics: ${e.message}"
                )
            )
        }
    }

    /**
     * Reset tiến độ một bài học
     */
    @DeleteMapping("/levels/{jlptLevel}/lessons/{lessonNumber}/progress")
    fun resetLessonProgress(
        @PathVariable jlptLevel: String,
        @PathVariable lessonNumber: Int,
        @AuthenticationPrincipal userDetails: UserDetails
    ): ResponseEntity<ApiResponse<String>> {
        return try {
            val userId = userDetails.username
            jlptVocabularyService.resetLessonProgress(userId, jlptLevel.uppercase(), lessonNumber)
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = "Progress reset successfully",
                    message = "Lesson progress has been reset"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error resetting progress: ${e.message}"
                )
            )
        }
    }

    /**
     * Reset toàn bộ tiến độ của một level
     */
    @DeleteMapping("/levels/{jlptLevel}/progress")
    fun resetLevelProgress(
        @PathVariable jlptLevel: String,
        @AuthenticationPrincipal userDetails: UserDetails
    ): ResponseEntity<ApiResponse<String>> {
        return try {
            val userId = userDetails.username
            jlptVocabularyService.resetLevelProgress(userId, jlptLevel.uppercase())
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = "Level progress reset successfully",
                    message = "$jlptLevel progress has been reset"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error resetting level progress: ${e.message}"
                )
            )
        }
    }

    /**
     * TEMPORARY: Generate a test JWT token for debugging
     */
    @GetMapping("/test/generate-token")
    fun generateTestToken(@RequestParam email: String): ResponseEntity<ApiResponse<String>> {
        return try {
            val token = jwtService.generateToken(email)
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = token,
                    message = "Test token generated successfully"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error generating token: ${e.message}"
                )
            )
        }
    }
}
