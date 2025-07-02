package com.nihongo.backend.presentation.controller

import com.nihongo.backend.application.service.KanjiService
import com.nihongo.backend.presentation.dto.response.ApiResponse
import com.nihongo.backend.presentation.dto.response.KanjiResponse
import com.nihongo.backend.presentation.dto.response.PaginatedResponse
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/learning/kanji")
@CrossOrigin(origins = ["*"])
class KanjiController(private val kanjiService: KanjiService) {

    @GetMapping("/level/{jlptLevel}")
    fun getKanjiByLevel(
        @PathVariable jlptLevel: Int,
        @RequestParam(defaultValue = "0") page: Int,
        @RequestParam(defaultValue = "20") size: Int
    ): ResponseEntity<ApiResponse<PaginatedResponse<KanjiResponse>>> {
        return try {
            if (jlptLevel !in 1..5) {
                ResponseEntity.badRequest().body(
                    ApiResponse(
                        success = false,
                        message = "JLPT level must be between 1 and 5"
                    )
                )
            } else {
                val kanji = kanjiService.getKanjiByLevel(jlptLevel, page, size)
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = kanji,
                        message = "Kanji retrieved successfully"
                    )
                )
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving kanji: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/{id}")
    fun getKanjiById(@PathVariable id: String): ResponseEntity<ApiResponse<KanjiResponse>> {
        return try {
            val kanji = kanjiService.getKanjiById(id)
            if (kanji != null) {
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = kanji,
                        message = "Kanji retrieved successfully"
                    )
                )
            } else {
                ResponseEntity.notFound().build()
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving kanji: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/search")
    fun searchKanji(
        @RequestParam keyword: String,
        @RequestParam(defaultValue = "0") page: Int,
        @RequestParam(defaultValue = "20") size: Int
    ): ResponseEntity<ApiResponse<PaginatedResponse<KanjiResponse>>> {
        return try {
            if (keyword.isBlank()) {
                ResponseEntity.badRequest().body(
                    ApiResponse(
                        success = false,
                        message = "Keyword cannot be empty"
                    )
                )
            } else {
                val kanji = kanjiService.searchKanji(keyword, page, size)
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = kanji,
                        message = "Search results retrieved successfully"
                    )
                )
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error searching kanji: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/stroke-count")
    fun getKanjiByStrokeCount(
        @RequestParam minStrokes: Int,
        @RequestParam maxStrokes: Int,
        @RequestParam(defaultValue = "0") page: Int,
        @RequestParam(defaultValue = "20") size: Int
    ): ResponseEntity<ApiResponse<PaginatedResponse<KanjiResponse>>> {
        return try {
            if (minStrokes < 1 || maxStrokes < minStrokes || maxStrokes > 30) {
                ResponseEntity.badRequest().body(
                    ApiResponse(
                        success = false,
                        message = "Invalid stroke count range"
                    )
                )
            } else {
                val kanji = kanjiService.getKanjiByStrokeCount(minStrokes, maxStrokes, page, size)
                ResponseEntity.ok(
                    ApiResponse(
                        success = true,
                        data = kanji,
                        message = "Kanji by stroke count retrieved successfully"
                    )
                )
            }
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving kanji by stroke count: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/radicals")
    fun getKanjiRadicals(): ResponseEntity<ApiResponse<List<String>>> {
        return try {
            val radicals = listOf(
                "人", "日", "木", "水", "火", "土", "金", "月", "女", "子",
                "心", "手", "口", "目", "耳", "足", "車", "食", "言", "見",
                "行", "来", "入", "出", "上", "下", "中", "大", "小", "長",
                "高", "安", "新", "古", "多", "少", "良", "悪", "美", "醜"
            )
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = radicals,
                    message = "Kanji radicals retrieved successfully"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving radicals: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/tags")
    fun getKanjiTags(): ResponseEntity<ApiResponse<List<String>>> {
        return try {
            val tags = listOf(
                "basic",
                "people",
                "time",
                "nature",
                "animals",
                "plants",
                "colors",
                "numbers",
                "body",
                "family",
                "school",
                "work",
                "food",
                "weather",
                "transportation",
                "emotions",
                "actions",
                "places",
                "objects",
                "abstract"
            )
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = tags,
                    message = "Kanji tags retrieved successfully"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving kanji tags: ${e.message}"
                )
            )
        }
    }
}
