package com.nihongo.backend.application.service

import com.nihongo.backend.domain.model.ListeningExercise
import com.nihongo.backend.domain.model.ListeningQuestion
import com.nihongo.backend.domain.model.ListeningDifficulty
import com.nihongo.backend.infrastructure.repository.ListeningExerciseRepository
import com.nihongo.backend.presentation.dto.response.ListeningExerciseResponse
import com.nihongo.backend.presentation.dto.response.ListeningQuestionResponse
import com.nihongo.backend.presentation.dto.response.PaginatedResponse
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.cache.annotation.Cacheable

@Service
class ListeningService(private val listeningExerciseRepository: ListeningExerciseRepository) {

    @Cacheable("listening")
    fun getListeningExercisesByLevel(jlptLevel: Int, page: Int = 0, size: Int = 20): PaginatedResponse<ListeningExerciseResponse> {
        val pageable = PageRequest.of(page, size, Sort.by("title"))
        var exercisePage = listeningExerciseRepository.findByJlptLevel(jlptLevel, pageable)
        
        // If no data in database, create sample data
        if (exercisePage.isEmpty) {
            createSampleListeningData(jlptLevel)
            exercisePage = listeningExerciseRepository.findByJlptLevel(jlptLevel, pageable)
        }
        
        return createPaginatedResponse(exercisePage)
    }

    fun getListeningExercisesByDifficulty(difficulty: String, page: Int = 0, size: Int = 20): PaginatedResponse<ListeningExerciseResponse> {
        val pageable = PageRequest.of(page, size, Sort.by("title"))
        val difficultyEnum = ListeningDifficulty.valueOf(difficulty.uppercase())
        val exercisePage = listeningExerciseRepository.findByDifficulty(difficultyEnum, pageable)
        return createPaginatedResponse(exercisePage)
    }

    fun searchListeningExercises(keyword: String, page: Int = 0, size: Int = 20): PaginatedResponse<ListeningExerciseResponse> {
        val pageable = PageRequest.of(page, size)
        val exercisePage = listeningExerciseRepository.searchByKeyword(keyword, pageable)
        return createPaginatedResponse(exercisePage)
    }

    fun getListeningExerciseById(id: String): ListeningExerciseResponse? {
        val exercise = listeningExerciseRepository.findById(id).orElse(null)
        return exercise?.let { mapToResponse(it) }
    }

    fun getListeningExercisesByCategory(category: String, page: Int = 0, size: Int = 20): PaginatedResponse<ListeningExerciseResponse> {
        val pageable = PageRequest.of(page, size, Sort.by("title"))
        val exercisePage = listeningExerciseRepository.findByCategory(category, pageable)
        return createPaginatedResponse(exercisePage)
    }

    private fun createSampleListeningData(jlptLevel: Int) {
        val listeningData = getSampleListeningData(jlptLevel)
        listeningExerciseRepository.saveAll(listeningData)
    }

    private fun getSampleListeningData(jlptLevel: Int): List<ListeningExercise> {
        return when (jlptLevel) {
            5 -> listOf(
                ListeningExercise(
                    title = "Tự giới thiệu cơ bản",
                    description = "Luyện nghe về cách tự giới thiệu bản thân",
                    audioUrl = "https://example.com/audio/n5_jikoshoukai.mp3",
                    transcript = "はじめまして。私の名前は田中です。二十歳です。学生です。日本人です。どうぞよろしくお願いします。",
                    transcriptHiragana = "はじめまして。わたしのなまえはたなかです。はたちです。がくせいです。にほんじんです。どうぞよろしくおねがいします。",
                    translation = "Xin chào lần đầu gặp. Tên tôi là Tanaka. Tôi 20 tuổi. Tôi là học sinh. Tôi là người Nhật. Xin hãy giúp đỡ.",
                    jlptLevel = 5,
                    duration = 30,
                    difficulty = ListeningDifficulty.BEGINNER,
                    category = "introduction",
                    questions = listOf(
                        ListeningQuestion(
                            question = "Tên của người nói là gì?",
                            options = listOf("Suzuki", "Tanaka", "Yamada", "Sato"),
                            correctAnswer = 1,
                            explanation = "Người nói nói '私の名前は田中です' (Tên tôi là Tanaka)"
                        ),
                        ListeningQuestion(
                            question = "Người nói bao nhiêu tuổi?",
                            options = listOf("18 tuổi", "19 tuổi", "20 tuổi", "21 tuổi"),
                            correctAnswer = 2,
                            explanation = "Người nói nói '二十歳です' (20 tuổi)"
                        )
                    ),
                    tags = listOf("introduction", "basic", "self-introduction")
                ),
                ListeningExercise(
                    title = "Mua sắm tại cửa hàng tiện lợi",
                    description = "Cuộc hội thoại mua đồ tại conbini",
                    audioUrl = "https://example.com/audio/n5_shopping.mp3",
                    transcript = "いらっしゃいませ。これはいくらですか。三百円です。ありがとうございます。",
                    transcriptHiragana = "いらっしゃいませ。これはいくらですか。さんびゃくえんです。ありがとうございます。",
                    translation = "Xin chào (chào khách). Cái này bao nhiêu tiền? 300 yên. Cảm ơn.",
                    jlptLevel = 5,
                    duration = 25,
                    difficulty = ListeningDifficulty.BEGINNER,
                    category = "shopping",
                    questions = listOf(
                        ListeningQuestion(
                            question = "Món đồ có giá bao nhiêu?",
                            options = listOf("200 yên", "300 yên", "400 yên", "500 yên"),
                            correctAnswer = 1,
                            explanation = "Nhân viên nói '三百円です' (300 yên)"
                        )
                    ),
                    tags = listOf("shopping", "price", "money")
                )
            )
            4 -> listOf(
                ListeningExercise(
                    title = "Cuộc trò chuyện về thời tiết",
                    description = "Hai người bàn luận về thời tiết hôm nay",
                    audioUrl = "https://example.com/audio/n4_weather.mp3",
                    transcript = "今日はいい天気ですね。そうですね。でも、明日は雨が降ると思います。そうですか。傘を持って行きましょう。",
                    transcriptHiragana = "きょうはいいてんきですね。そうですね。でも、あしたはあめがふるとおもいます。そうですか。かさをもっていきましょう。",
                    translation = "Hôm nay thời tiết đẹp nhỉ. Đúng vậy. Nhưng tôi nghĩ ngày mai sẽ mưa. Vậy à. Hãy mang theo ô nhé.",
                    jlptLevel = 4,
                    duration = 45,
                    difficulty = ListeningDifficulty.INTERMEDIATE,
                    category = "weather",
                    questions = listOf(
                        ListeningQuestion(
                            question = "Thời tiết hôm nay như thế nào?",
                            options = listOf("Mưa", "Đẹp", "Lạnh", "Nóng"),
                            correctAnswer = 1,
                            explanation = "Người nói đầu tiên nói 'いい天気ですね' (thời tiết đẹp nhỉ)"
                        ),
                        ListeningQuestion(
                            question = "Người nói nghĩ ngày mai sẽ như thế nào?",
                            options = listOf("Nắng", "Mưa", "Tuyết", "Gió"),
                            correctAnswer = 1,
                            explanation = "Người thứ hai nói '明日は雨が降ると思います' (tôi nghĩ ngày mai sẽ mưa)"
                        )
                    ),
                    tags = listOf("weather", "prediction", "daily-conversation")
                ),
                ListeningExercise(
                    title = "Đặt lịch hẹn gặp bác sĩ",
                    description = "Cuộc gọi điện thoại đặt lịch khám bệnh",
                    audioUrl = "https://example.com/audio/n4_appointment.mp3",
                    transcript = "もしもし、病院です。予約を取りたいんですが。いつがいいですか。来週の金曜日はどうですか。はい、大丈夫です。",
                    transcriptHiragana = "もしもし、びょういんです。よやくをとりたいんですが。いつがいいですか。らいしゅうのきんようびはどうですか。はい、だいじょうぶです。",
                    translation = "Xin chào, đây là bệnh viện. Tôi muốn đặt lịch hẹn. Khi nào thì tốt? Thứ sáu tuần tới thì sao? Vâng, được.",
                    jlptLevel = 4,
                    duration = 60,
                    difficulty = ListeningDifficulty.INTERMEDIATE,
                    category = "medical",
                    questions = listOf(
                        ListeningQuestion(
                            question = "Người gọi muốn làm gì?",
                            options = listOf("Hỏi giờ", "Đặt lịch hẹn", "Hỏi đường", "Mua thuốc"),
                            correctAnswer = 1,
                            explanation = "Người gọi nói '予約を取りたいんですが' (tôi muốn đặt lịch hẹn)"
                        ),
                        ListeningQuestion(
                            question = "Lịch hẹn được đặt vào thứ mấy?",
                            options = listOf("Thứ ba", "Thứ tư", "Thứ năm", "Thứ sáu"),
                            correctAnswer = 3,
                            explanation = "Nhân viên đề xuất '来週の金曜日' (thứ sáu tuần tới)"
                        )
                    ),
                    tags = listOf("medical", "appointment", "phone-call")
                )
            )
            3 -> listOf(
                ListeningExercise(
                    title = "Phỏng vấn xin việc",
                    description = "Cuộc phỏng vấn cho vị trí nhân viên công ty",
                    audioUrl = "https://example.com/audio/n3_interview.mp3",
                    transcript = "自己紹介をお願いします。私は大学で経済学を専攻していました。アルバイトの経験もあります。この会社で働きたい理由は何ですか。",
                    transcriptHiragana = "じこしょうかいをおねがいします。わたしはだいがくでけいざいがくをせんこうしていました。アルバイトのけいけんもあります。このかいしゃではたらきたいりゆうはなんですか。",
                    translation = "Xin hãy tự giới thiệu. Tôi đã học chuyên ngành kinh tế ở đại học. Tôi cũng có kinh nghiệm làm thêm. Lý do bạn muốn làm việc ở công ty này là gì?",
                    jlptLevel = 3,
                    duration = 120,
                    difficulty = ListeningDifficulty.ADVANCED,
                    category = "interview",
                    questions = listOf(
                        ListeningQuestion(
                            question = "Người được phỏng vấn học chuyên ngành gì?",
                            options = listOf("Văn học", "Kinh tế", "Khoa học", "Kỹ thuật"),
                            correctAnswer = 1,
                            explanation = "Người được phỏng vấn nói '経済学を専攻していました' (đã học chuyên ngành kinh tế)"
                        )
                    ),
                    tags = listOf("interview", "job", "business", "formal")
                )
            )
            else -> emptyList()
        }
    }

    private fun createPaginatedResponse(page: org.springframework.data.domain.Page<ListeningExercise>): PaginatedResponse<ListeningExerciseResponse> {
        return PaginatedResponse(
            items = page.content.map { mapToResponse(it) },
            totalItems = page.totalElements,
            currentPage = page.number,
            totalPages = page.totalPages,
            hasNext = page.hasNext(),
            hasPrevious = page.hasPrevious()
        )
    }

    private fun mapToResponse(exercise: ListeningExercise): ListeningExerciseResponse {
        return ListeningExerciseResponse(
            id = exercise.id,
            title = exercise.title,
            description = exercise.description,
            audioUrl = exercise.audioUrl,
            transcript = exercise.transcript,
            transcriptHiragana = exercise.transcriptHiragana,
            translation = exercise.translation,
            jlptLevel = exercise.jlptLevel,
            duration = exercise.duration,
            difficulty = exercise.difficulty.name,
            category = exercise.category,
            questions = exercise.questions.map {
                ListeningQuestionResponse(
                    question = it.question,
                    options = it.options,
                    correctAnswer = it.correctAnswer,
                    explanation = it.explanation,
                    timestamp = it.timestamp
                )
            },
            vocabulary = exercise.vocabulary,
            tags = exercise.tags
        )
    }
}
