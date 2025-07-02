package com.nihongo.backend.presentation.controller

import com.nihongo.backend.presentation.dto.response.ApiResponse
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/learning")
@CrossOrigin(origins = ["*"])
class LearningOverviewController {

    @GetMapping("/overview")
    fun getLearningOverview(): ResponseEntity<ApiResponse<Map<String, Any>>> {
        return try {
            val overview = mapOf(
                "modules" to listOf(
                    mapOf(
                        "id" to "vocabulary",
                        "name" to "Từ vựng",
                        "nameEn" to "Vocabulary",
                        "description" to "Học từ vựng tiếng Nhật theo cấp độ JLPT",
                        "icon" to "vocabulary",
                        "color" to "#4CAF50",
                        "endpoint" to "/api/learning/vocabulary"
                    ),
                    mapOf(
                        "id" to "grammar",
                        "name" to "Ngữ pháp",
                        "nameEn" to "Grammar",
                        "description" to "Học ngữ pháp tiếng Nhật với ví dụ cụ thể",
                        "icon" to "grammar",
                        "color" to "#2196F3",
                        "endpoint" to "/api/learning/grammar"
                    ),
                    mapOf(
                        "id" to "kanji",
                        "name" to "Kanji",
                        "nameEn" to "Kanji",
                        "description" to "Học chữ Hán với cách đọc và ý nghĩa",
                        "icon" to "kanji",
                        "color" to "#FF9800",
                        "endpoint" to "/api/learning/kanji"
                    ),
                    mapOf(
                        "id" to "listening",
                        "name" to "Luyện nghe",
                        "nameEn" to "Listening",
                        "description" to "Luyện nghe với các tình huống thực tế",
                        "icon" to "listening",
                        "color" to "#E91E63",
                        "endpoint" to "/api/learning/listening"
                    )
                ),
                "jlptLevels" to listOf(
                    mapOf(
                        "level" to 5,
                        "name" to "N5 - Cơ bản",
                        "description" to "Cấp độ sơ cấp, học các từ vựng và ngữ pháp cơ bản nhất",
                        "color" to "#4CAF50"
                    ),
                    mapOf(
                        "level" to 4,
                        "name" to "N4 - Sơ cấp",
                        "description" to "Cấp độ sơ cấp nâng cao, mở rộng từ vựng và ngữ pháp",
                        "color" to "#8BC34A"
                    ),
                    mapOf(
                        "level" to 3,
                        "name" to "N3 - Trung cấp",
                        "description" to "Cấp độ trung cấp, ngữ pháp phức tạp hơn",
                        "color" to "#FF9800"
                    ),
                    mapOf(
                        "level" to 2,
                        "name" to "N2 - Trung cấp cao",
                        "description" to "Cấp độ trung cấp cao, chuẩn bị cho môi trường công việc",
                        "color" to "#FF5722"
                    ),
                    mapOf(
                        "level" to 1,
                        "name" to "N1 - Cao cấp",
                        "description" to "Cấp độ cao nhất, thành thạo tiếng Nhật",
                        "color" to "#F44336"
                    )
                ),
                "features" to listOf(
                    "Học theo cấp độ JLPT",
                    "Từ vựng có ví dụ và cách phát âm",
                    "Ngữ pháp có giải thích chi tiết",
                    "Kanji với cách viết và ý nghĩa",
                    "Luyện nghe với câu hỏi tương tác",
                    "Tìm kiếm thông minh",
                    "Phân loại theo chủ đề",
                    "Cập nhật dữ liệu từ API bên ngoài"
                ),
                "stats" to mapOf(
                    "totalVocabulary" to "1000+",
                    "totalGrammar" to "500+",
                    "totalKanji" to "2000+",
                    "totalListening" to "200+"
                )
            )
            
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = overview,
                    message = "Learning overview retrieved successfully"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Error retrieving learning overview: ${e.message}"
                )
            )
        }
    }

    @GetMapping("/health")
    fun getHealthCheck(): ResponseEntity<ApiResponse<Map<String, String>>> {
        return try {
            val health = mapOf(
                "status" to "UP",
                "timestamp" to System.currentTimeMillis().toString(),
                "version" to "1.0.0",
                "environment" to "development"
            )
            
            ResponseEntity.ok(
                ApiResponse(
                    success = true,
                    data = health,
                    message = "Service is healthy"
                )
            )
        } catch (e: Exception) {
            ResponseEntity.internalServerError().body(
                ApiResponse(
                    success = false,
                    message = "Service is not healthy: ${e.message}"
                )
            )
        }
    }
}
