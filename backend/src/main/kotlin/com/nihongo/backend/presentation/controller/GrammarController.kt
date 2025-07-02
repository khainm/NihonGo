package com.nihongo.backend.presentation.controller

import com.nihongo.backend.application.service.GrammarService
import com.nihongo.backend.presentation.dto.response.ApiResponse
import com.nihongo.backend.presentation.dto.response.GrammarResponse
import com.nihongo.backend.presentation.dto.response.PaginatedResponse
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/learning/grammar")
@CrossOrigin(origins = ["*"])
class GrammarController(private val grammarService: GrammarService) {

    @GetMapping("/level/{jlptLevel}")
    fun getGrammarByLevel(
        @PathVariable jlptLevel: Int,
        @RequestParam(defaultValue = "0") page: Int,
        @RequestParam(defaultValue = "20") size: Int
    ): ResponseEntity<ApiResponse<PaginatedResponse<GrammarResponse>>> {
        return try {
            if (jlptLevel !in 1..5) {
                ResponseEntity.badRequest().body(
                    ApiResponse(
                        success = false,
                        message = "JLPT level must be between 1 and 5"
                    )
                )
            } else {
                val grammar = grammarService.getGrammarByLevel(jlptLevel, page, size)
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = grammar,
                        message = "Grammar points retrieved successfully"
                    )
                )
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving grammar: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/{id}")
    fun getGrammarById(@PathVariable id: String): ResponseEntity<ApiResponse<GrammarResponse>> {
        return try {
            val grammar = grammarService.getGrammarById(id)
            if (grammar != null) {
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = grammar,
                        message = "Grammar point retrieved successfully"
                    )
                )
            } else {
                ResponseEntity.notFound().build()
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving grammar: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/search")
    fun searchGrammar(
        @RequestParam keyword: String,
        @RequestParam(defaultValue = "0") page: Int,
        @RequestParam(defaultValue = "20") size: Int
    ): ResponseEntity<ApiResponse<PaginatedResponse<GrammarResponse>>> {
        return try {
            if (keyword.isBlank()) {
                ResponseEntity.badRequest().body(
                    ApiResponse(
                        success = false,
                        message = "Keyword cannot be empty"
                    )
                )
            } else {
                val grammar = grammarService.searchGrammar(keyword, page, size)
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = grammar,
                        message = "Search results retrieved successfully"
                    )
                )
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error searching grammar: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/formality-types")
    fun getFormalityTypes(): ResponseEntity<ApiResponse<List<String>>> {
        return try {
            val types = listOf("FORMAL", "INFORMAL", "BOTH")
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = types,
                    message = "Formality types retrieved successfully"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving formality types: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/tags")
    fun getGrammarTags(): ResponseEntity<ApiResponse<List<String>>> {
        return try {
            val tags = listOf(
                "copula",
                "verb",
                "particle",
                "adjective",
                "tense",
                "conditional",
                "causative",
                "passive",
                "potential",
                "imperative",
                "honorific",
                "humble",
                "question",
                "negation",
                "comparison",
                "time",
                "location",
                "reason",
                "purpose",
                "result"
            )
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = tags,
                    message = "Grammar tags retrieved successfully"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving grammar tags: ${e.message}"
                )
            )
        }
    }
}
