package com.nihongo.backend.infrastructure.client

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty
import org.springframework.stereotype.Component
import org.springframework.web.reactive.function.client.WebClient
import reactor.core.publisher.Mono

@Component
class JishoApiClient(private val webClient: WebClient = WebClient.create("https://jisho.org")) {

    fun searchWord(keyword: String): Mono<JishoResponse> {
        return webClient.get()
            .uri("/api/v1/search/words?keyword={keyword}", keyword)
            .retrieve()
            .bodyToMono(JishoResponse::class.java)
            .onErrorReturn(JishoResponse(emptyList(), JishoMeta()))
    }
}

@JsonIgnoreProperties(ignoreUnknown = true)
data class JishoResponse(
    val data: List<JishoData>,
    val meta: JishoMeta
)

@JsonIgnoreProperties(ignoreUnknown = true)
data class JishoMeta(
    val status: Int = 200
)

@JsonIgnoreProperties(ignoreUnknown = true)
data class JishoData(
    val slug: String = "",
    val japanese: List<JishoJapanese> = emptyList(),
    val senses: List<JishoSense> = emptyList(),
    @JsonProperty("is_common") val isCommon: Boolean = false,
    val tags: List<String> = emptyList(),
    val jlpt: List<String> = emptyList()
)

@JsonIgnoreProperties(ignoreUnknown = true)
data class JishoJapanese(
    val word: String? = null,
    val reading: String? = null
)

@JsonIgnoreProperties(ignoreUnknown = true)
data class JishoSense(
    @JsonProperty("english_definitions") val englishDefinitions: List<String> = emptyList(),
    @JsonProperty("parts_of_speech") val partsOfSpeech: List<String> = emptyList(),
    val links: List<JishoLink> = emptyList(),
    val tags: List<String> = emptyList(),
    val restrictions: List<String> = emptyList(),
    @JsonProperty("see_also") val seeAlso: List<String> = emptyList(),
    val antonyms: List<String> = emptyList(),
    val source: List<String> = emptyList(),
    val info: List<String> = emptyList()
)

@JsonIgnoreProperties(ignoreUnknown = true)
data class JishoLink(
    val text: String = "",
    val url: String = ""
)
