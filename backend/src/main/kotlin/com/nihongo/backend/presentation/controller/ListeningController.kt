package com.nihongo.backend.presentation.controller

import com.nihongo.backend.application.service.ListeningService
import com.nihongo.backend.presentation.dto.response.ApiResponse
import com.nihongo.backend.presentation.dto.response.ListeningExerciseResponse
import com.nihongo.backend.presentation.dto.response.PaginatedResponse
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/learning/listening")
@CrossOrigin(origins = ["*"])
class ListeningController(private val listeningService: ListeningService) {

    @GetMapping("/level/{jlptLevel}")
    fun getListeningExercisesByLevel(
        @PathVariable jlptLevel: Int,
        @RequestParam(defaultValue = "0") page: Int,
        @RequestParam(defaultValue = "20") size: Int
    ): ResponseEntity<ApiResponse<PaginatedResponse<ListeningExerciseResponse>>> {
        return try {
            if (jlptLevel !in 1..5) {
                ResponseEntity.badRequest().body(
                    ApiResponse(
                        success = false,
                        message = "JLPT level must be between 1 and 5"
                    )
                )
            } else {
                val exercises = listeningService.getListeningExercisesByLevel(jlptLevel, page, size)
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = exercises,
                        message = "Listening exercises retrieved successfully"
                    )
                )
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving listening exercises: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/{id}")
    fun getListeningExerciseById(@PathVariable id: String): ResponseEntity<ApiResponse<ListeningExerciseResponse>> {
        return try {
            val exercise = listeningService.getListeningExerciseById(id)
            if (exercise != null) {
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = exercise,
                        message = "Listening exercise retrieved successfully"
                    )
                )
            } else {
                ResponseEntity.notFound().build()
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving listening exercise: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/difficulty/{difficulty}")
    fun getListeningExercisesByDifficulty(
        @PathVariable difficulty: String,
        @RequestParam(defaultValue = "0") page: Int,
        @RequestParam(defaultValue = "20") size: Int
    ): ResponseEntity<ApiResponse<PaginatedResponse<ListeningExerciseResponse>>> {
        return try {
            val validDifficulties = listOf("BEGINNER", "INTERMEDIATE", "ADVANCED")
            if (difficulty.uppercase() !in validDifficulties) {
                ResponseEntity.badRequest().body(
                    ApiResponse(
                        success = false,
                        message = "Invalid difficulty. Must be one of: ${validDifficulties.joinToString(", ")}"
                    )
                )
            } else {
                val exercises = listeningService.getListeningExercisesByDifficulty(difficulty, page, size)
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = exercises,
                        message = "Listening exercises by difficulty retrieved successfully"
                    )
                )
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving listening exercises by difficulty: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/category/{category}")
    fun getListeningExercisesByCategory(
        @PathVariable category: String,
        @RequestParam(defaultValue = "0") page: Int,
        @RequestParam(defaultValue = "20") size: Int
    ): ResponseEntity<ApiResponse<PaginatedResponse<ListeningExerciseResponse>>> {
        return try {
            val exercises = listeningService.getListeningExercisesByCategory(category, page, size)
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = exercises,
                    message = "Listening exercises by category retrieved successfully"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving listening exercises by category: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/search")
    fun searchListeningExercises(
        @RequestParam keyword: String,
        @RequestParam(defaultValue = "0") page: Int,
        @RequestParam(defaultValue = "20") size: Int
    ): ResponseEntity<ApiResponse<PaginatedResponse<ListeningExerciseResponse>>> {
        return try {
            if (keyword.isBlank()) {
                ResponseEntity.badRequest().body(
                    ApiResponse(
                        success = false,
                        message = "Keyword cannot be empty"
                    )
                )
            } else {
                val exercises = listeningService.searchListeningExercises(keyword, page, size)
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = exercises,
                        message = "Search results retrieved successfully"
                    )
                )
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error searching listening exercises: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/categories")
    fun getListeningCategories(): ResponseEntity<ApiResponse<List<String>>> {
        return try {
            val categories = listOf(
                "introduction",
                "shopping",
                "weather",
                "medical",
                "interview",
                "restaurant",
                "transportation",
                "hotel",
                "school",
                "business",
                "family",
                "hobbies",
                "travel",
                "news",
                "daily-conversation",
                "phone-call",
                "announcement",
                "directions",
                "sports",
                "culture"
            )
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = categories,
                    message = "Listening categories retrieved successfully"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving listening categories: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/difficulties")
    fun getListeningDifficulties(): ResponseEntity<ApiResponse<List<String>>> {
        return try {
            val difficulties = listOf("BEGINNER", "INTERMEDIATE", "ADVANCED")
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = difficulties,
                    message = "Listening difficulties retrieved successfully"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving listening difficulties: ${e.message}"
                )
            )
        }
    }
}
