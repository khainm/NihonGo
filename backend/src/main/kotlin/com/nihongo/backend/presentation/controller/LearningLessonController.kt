package com.nihongo.backend.presentation.controller

import com.nihongo.backend.application.service.LearningLessonService
import com.nihongo.backend.presentation.dto.request.UpdateLessonProgressRequest
import com.nihongo.backend.presentation.dto.response.ApiResponse
import com.nihongo.backend.presentation.dto.response.LearningLessonResponse
import com.nihongo.backend.presentation.dto.response.PaginatedResponse
import com.nihongo.backend.presentation.dto.response.UserProgressSummaryResponse
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/learning/lessons")
@CrossOrigin(origins = ["*"])
class LearningLessonController(private val learningLessonService: LearningLessonService) {

    @GetMapping("/type/{type}")
    fun getLessonsByType(
        @PathVariable type: String,
        @RequestParam(required = false) jlptLevel: Int?,
        @RequestParam(defaultValue = "0") page: Int,
        @RequestParam(defaultValue = "20") size: Int,
        @RequestParam(required = false) userId: String?
    ): ResponseEntity<ApiResponse<PaginatedResponse<LearningLessonResponse>>> {
        return try {
            val validTypes = listOf("VOCABULARY", "GRAMMAR", "KANJI", "LISTENING")
            if (type.uppercase() !in validTypes) {
                ResponseEntity.badRequest().body(
                    ApiResponse(
                        success = false,
                        message = "Invalid lesson type. Must be one of: ${validTypes.joinToString(", ")}"
                    )
                )
            } else if (jlptLevel != null && jlptLevel !in 1..5) {
                ResponseEntity.badRequest().body(
                    ApiResponse(
                        success = false,
                        message = "JLPT level must be between 1 and 5"
                    )
                )
            } else {
                val lessons = learningLessonService.getLessonsByType(type, jlptLevel, page, size, userId)
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = lessons,
                        message = "Lessons retrieved successfully"
                    )
                )
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving lessons: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/{lessonId}")
    fun getLessonDetail(
        @PathVariable lessonId: String,
        @RequestParam(required = false) userId: String?
    ): ResponseEntity<ApiResponse<Any>> {
        return try {
            val lessonDetail = learningLessonService.getLessonDetail(lessonId, userId)
            if (lessonDetail != null) {
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = lessonDetail,
                        message = "Lesson detail retrieved successfully"
                    )
                )
            } else {
                ResponseEntity.notFound().build()
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving lesson detail: ${e.message}"
                )
            )
        }
    }

    @PostMapping("/progress/{userId}")
    fun updateLessonProgress(
        @PathVariable userId: String,
        @RequestBody request: UpdateLessonProgressRequest
    ): ResponseEntity<ApiResponse<Any>> {
        return try {
            val progress = learningLessonService.updateLessonProgress(userId, request)
            if (progress != null) {
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = progress,
                        message = "Progress updated successfully"
                    )
                )
            } else {
                ResponseEntity.badRequest().body(
                    ApiResponse(
                        success = false,
                        message = "Invalid lesson ID or request data"
                    )
                )
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error updating progress: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/progress/{userId}/summary")
    fun getUserProgressSummary(
        @PathVariable userId: String
    ): ResponseEntity<ApiResponse<UserProgressSummaryResponse>> {
        return try {
            val summary = learningLessonService.getUserProgressSummary(userId)
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = summary,
                    message = "Progress summary retrieved successfully"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving progress summary: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/search")
    fun searchLessons(
        @RequestParam keyword: String,
        @RequestParam(defaultValue = "0") page: Int,
        @RequestParam(defaultValue = "20") size: Int,
        @RequestParam(required = false) userId: String?
    ): ResponseEntity<ApiResponse<PaginatedResponse<LearningLessonResponse>>> {
        return try {
            if (keyword.isBlank()) {
                ResponseEntity.badRequest().body(
                    ApiResponse(
                        success = false,
                        message = "Keyword cannot be empty"
                    )
                )
            } else {
                val lessons = learningLessonService.searchLessons(keyword, page, size, userId)
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = lessons,
                        message = "Search results retrieved successfully"
                    )
                )
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error searching lessons: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/types")
    fun getLessonTypes(): ResponseEntity<ApiResponse<List<String>>> {
        return try {
            val types = listOf("VOCABULARY", "GRAMMAR", "KANJI", "LISTENING")
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = types,
                    message = "Lesson types retrieved successfully"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving lesson types: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/difficulties")
    fun getLessonDifficulties(): ResponseEntity<ApiResponse<List<String>>> {
        return try {
            val difficulties = listOf("BEGINNER", "INTERMEDIATE", "ADVANCED")
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = difficulties,
                    message = "Lesson difficulties retrieved successfully"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving lesson difficulties: ${e.message}"
                )
            )
        }
    }
}
