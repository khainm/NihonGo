package com.nihongo.backend.application.service

import com.nihongo.backend.domain.model.GrammarPoint
import com.nihongo.backend.domain.model.GrammarExample
import com.nihongo.backend.domain.model.GrammarFormality
import com.nihongo.backend.infrastructure.repository.GrammarRepository
import com.nihongo.backend.presentation.dto.response.GrammarResponse
import com.nihongo.backend.presentation.dto.response.GrammarExampleResponse
import com.nihongo.backend.presentation.dto.response.PaginatedResponse
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.cache.annotation.Cacheable

@Service
class GrammarService(private val grammarRepository: GrammarRepository) {

    @Cacheable("grammar")
    fun getGrammarByLevel(jlptLevel: Int, page: Int = 0, size: Int = 20): PaginatedResponse<GrammarResponse> {
        val pageable = PageRequest.of(page, size, Sort.by("title"))
        var grammarPage = grammarRepository.findByJlptLevel(jlptLevel, pageable)
        
        // If no data in database, create sample data
        if (grammarPage.isEmpty) {
            createSampleGrammarData(jlptLevel)
            grammarPage = grammarRepository.findByJlptLevel(jlptLevel, pageable)
        }
        
        return createPaginatedResponse(grammarPage)
    }

    fun searchGrammar(keyword: String, page: Int = 0, size: Int = 20): PaginatedResponse<GrammarResponse> {
        val pageable = PageRequest.of(page, size)
        val grammarPage = grammarRepository.searchByKeyword(keyword, pageable)
        return createPaginatedResponse(grammarPage)
    }

    fun getGrammarById(id: String): GrammarResponse? {
        val grammar = grammarRepository.findById(id).orElse(null)
        return grammar?.let { mapToResponse(it) }
    }

    private fun createSampleGrammarData(jlptLevel: Int) {
        val grammarData = getSampleGrammarData(jlptLevel)
        grammarRepository.saveAll(grammarData)
    }

    private fun getSampleGrammarData(jlptLevel: Int): List<GrammarPoint> {
        return when (jlptLevel) {
            5 -> listOf(
                GrammarPoint(
                    title = "です/だ",
                    structure = "[Danh từ] + です/だ",
                    meaning = "Copula - từ liên kết chủ ngữ và vị ngữ",
                    usage = "Được dùng để nói về trạng thái, danh tính hoặc mô tả của chủ ngữ",
                    jlptLevel = 5,
                    formality = GrammarFormality.BOTH,
                    examples = listOf(
                        GrammarExample(
                            japanese = "私は学生です。",
                            hiragana = "わたしはがくせいです。",
                            vietnamese = "Tôi là học sinh.",
                            english = "I am a student."
                        ),
                        GrammarExample(
                            japanese = "これは本だ。",
                            hiragana = "これはほんだ。",
                            vietnamese = "Đây là cuốn sách.",
                            english = "This is a book."
                        )
                    ),
                    tags = listOf("copula", "basic", "identity")
                ),
                GrammarPoint(
                    title = "～ます",
                    structure = "[Động từ thể masu] + ます",
                    meaning = "Thể lịch sự của động từ",
                    usage = "Dùng trong các tình huống trang trọng, lịch sự",
                    jlptLevel = 5,
                    formality = GrammarFormality.FORMAL,
                    examples = listOf(
                        GrammarExample(
                            japanese = "私は日本語を勉強します。",
                            hiragana = "わたしはにほんごをべんきょうします。",
                            vietnamese = "Tôi học tiếng Nhật.",
                            english = "I study Japanese."
                        ),
                        GrammarExample(
                            japanese = "明日学校に行きます。",
                            hiragana = "あしたがっこうにいきます。",
                            vietnamese = "Ngày mai tôi sẽ đi học.",
                            english = "I will go to school tomorrow."
                        )
                    ),
                    tags = listOf("verb", "polite", "masu-form")
                ),
                GrammarPoint(
                    title = "が (Subject marker)",
                    structure = "[Chủ ngữ] + が",
                    meaning = "Trợ từ đánh dấu chủ ngữ",
                    usage = "Dùng để chỉ ra chủ ngữ của câu, thường trong câu hỏi hoặc khi giới thiệu thông tin mới",
                    jlptLevel = 5,
                    formality = GrammarFormality.BOTH,
                    examples = listOf(
                        GrammarExample(
                            japanese = "誰が来ますか？",
                            hiragana = "だれがきますか？",
                            vietnamese = "Ai sẽ đến?",
                            english = "Who is coming?"
                        ),
                        GrammarExample(
                            japanese = "雨が降っています。",
                            hiragana = "あめがふっています。",
                            vietnamese = "Trời đang mưa.",
                            english = "It is raining."
                        )
                    ),
                    tags = listOf("particle", "subject", "ga")
                )
            )
            4 -> listOf(
                GrammarPoint(
                    title = "～と思います",
                    structure = "[Câu thông thường] + と思います",
                    meaning = "Tôi nghĩ rằng...",
                    usage = "Dùng để bày tỏ ý kiến cá nhân một cách lịch sự",
                    jlptLevel = 4,
                    formality = GrammarFormality.FORMAL,
                    examples = listOf(
                        GrammarExample(
                            japanese = "明日は雨が降ると思います。",
                            hiragana = "あしたはあめがふるとおもいます。",
                            vietnamese = "Tôi nghĩ ngày mai sẽ mưa.",
                            english = "I think it will rain tomorrow."
                        ),
                        GrammarExample(
                            japanese = "彼は来ないと思います。",
                            hiragana = "かれはこないとおもいます。",
                            vietnamese = "Tôi nghĩ anh ấy sẽ không đến.",
                            english = "I think he won't come."
                        )
                    ),
                    tags = listOf("opinion", "to-omoimasu", "thinking")
                ),
                GrammarPoint(
                    title = "～たことがあります",
                    structure = "[Động từ thể た] + ことがあります",
                    meaning = "Đã từng làm gì đó (kinh nghiệm)",
                    usage = "Dùng để nói về kinh nghiệm trong quá khứ",
                    jlptLevel = 4,
                    formality = GrammarFormality.FORMAL,
                    examples = listOf(
                        GrammarExample(
                            japanese = "日本に行ったことがあります。",
                            hiragana = "にほんにいったことがあります。",
                            vietnamese = "Tôi đã từng đi Nhật Bản.",
                            english = "I have been to Japan."
                        ),
                        GrammarExample(
                            japanese = "寿司を食べたことがありますか？",
                            hiragana = "すしをたべたことがありますか？",
                            vietnamese = "Bạn đã từng ăn sushi chưa?",
                            english = "Have you ever eaten sushi?"
                        )
                    ),
                    tags = listOf("experience", "ta-koto-ga-arimasu", "past")
                )
            )
            3 -> listOf(
                GrammarPoint(
                    title = "～ば",
                    structure = "[Động từ thể ば] + [Kết quả]",
                    meaning = "Nếu... thì...",
                    usage = "Dùng để diễn tả điều kiện",
                    jlptLevel = 3,
                    formality = GrammarFormality.BOTH,
                    examples = listOf(
                        GrammarExample(
                            japanese = "時間があれば、映画を見ます。",
                            hiragana = "じかんがあれば、えいがをみます。",
                            vietnamese = "Nếu có thời gian thì tôi sẽ xem phim.",
                            english = "If I have time, I will watch a movie."
                        )
                    ),
                    tags = listOf("conditional", "ba-form", "if")
                )
            )
            else -> emptyList()
        }
    }

    private fun createPaginatedResponse(page: org.springframework.data.domain.Page<GrammarPoint>): PaginatedResponse<GrammarResponse> {
        return PaginatedResponse(
            items = page.content.map { mapToResponse(it) },
            totalItems = page.totalElements,
            currentPage = page.number,
            totalPages = page.totalPages,
            hasNext = page.hasNext(),
            hasPrevious = page.hasPrevious()
        )
    }

    private fun mapToResponse(grammar: GrammarPoint): GrammarResponse {
        return GrammarResponse(
            id = grammar.id,
            title = grammar.title,
            structure = grammar.structure,
            meaning = grammar.meaning,
            usage = grammar.usage,
            jlptLevel = grammar.jlptLevel,
            formality = grammar.formality.name,
            examples = grammar.examples.map {
                GrammarExampleResponse(
                    japanese = it.japanese,
                    hiragana = it.hiragana,
                    vietnamese = it.vietnamese,
                    english = it.english,
                    note = it.note
                )
            },
            relatedGrammar = grammar.relatedGrammar,
            tags = grammar.tags
        )
    }
}
