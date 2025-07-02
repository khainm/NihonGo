package com.nihongo.backend.presentation.controller

import com.nihongo.backend.infrastructure.client.JishoApiClient
import com.nihongo.backend.presentation.dto.response.ApiResponse
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/test")
@CrossOrigin(origins = ["*"])
class TestController(private val jishoApiClient: JishoApiClient) {

    @GetMapping("/jisho/{keyword}")
    fun testJishoApi(@PathVariable keyword: String): ResponseEntity<ApiResponse<Any>> {
        return try {
            val response = jishoApiClient.searchWord(keyword).block()
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = response,
                    message = "Jisho API response retrieved successfully"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error calling Jisho API: ${e.message}"
                )
            )
        }
    }
}
