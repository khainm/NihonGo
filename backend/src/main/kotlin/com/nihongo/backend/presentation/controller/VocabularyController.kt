package com.nihongo.backend.presentation.controller

import com.nihongo.backend.application.service.VocabularyService
import com.nihongo.backend.presentation.dto.response.ApiResponse
import com.nihongo.backend.presentation.dto.response.VocabularyResponse
import com.nihongo.backend.presentation.dto.response.PaginatedResponse
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/learning/vocabulary")
@CrossOrigin(origins = ["*"])
class VocabularyController(private val vocabularyService: VocabularyService) {

    @GetMapping("/level/{jlptLevel}")
    fun getVocabulariesByLevel(
        @PathVariable jlptLevel: Int,
        @RequestParam(defaultValue = "0") page: Int,
        @RequestParam(defaultValue = "20") size: Int,
        @RequestParam(required = false) category: String?
    ): ResponseEntity<ApiResponse<PaginatedResponse<VocabularyResponse>>> {
        return try {
            if (jlptLevel !in 1..5) {
                ResponseEntity.badRequest().body(
                    ApiResponse(
                        success = false,
                        message = "JLPT level must be between 1 and 5"
                    )
                )
            } else {
                val vocabularies = vocabularyService.getVocabulariesByLevel(jlptLevel, page, size, category)
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = vocabularies,
                        message = "Vocabularies retrieved successfully"
                    )
                )
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving vocabularies: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/{id}")
    fun getVocabularyById(@PathVariable id: String): ResponseEntity<ApiResponse<VocabularyResponse>> {
        return try {
            val vocabulary = vocabularyService.getVocabularyById(id)
            if (vocabulary != null) {
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = vocabulary,
                        message = "Vocabulary retrieved successfully"
                    )
                )
            } else {
                ResponseEntity.notFound().build()
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving vocabulary: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/search")
    fun searchVocabulary(
        @RequestParam keyword: String,
        @RequestParam(defaultValue = "0") page: Int,
        @RequestParam(defaultValue = "20") size: Int
    ): ResponseEntity<ApiResponse<PaginatedResponse<VocabularyResponse>>> {
        return try {
            if (keyword.isBlank()) {
                ResponseEntity.badRequest().body(
                    ApiResponse(
                        success = false,
                        message = "Keyword cannot be empty"
                    )
                )
            } else {
                val vocabularies = vocabularyService.searchVocabulary(keyword, page, size)
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = vocabularies,
                        message = "Search results retrieved successfully"
                    )
                )
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error searching vocabularies: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/categories")
    fun getVocabularyCategories(): ResponseEntity<ApiResponse<List<String>>> {
        return try {
            val categories = listOf(
                "greeting",
                "education", 
                "nature",
                "food",
                "family",
                "time",
                "numbers",
                "colors",
                "body",
                "clothing",
                "transportation",
                "weather",
                "emotions",
                "activities",
                "other"
            )
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = categories,
                    message = "Categories retrieved successfully"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving categories: ${e.message}"
                )
            )
        }
    }
}
