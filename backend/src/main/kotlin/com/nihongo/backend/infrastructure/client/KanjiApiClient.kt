package com.nihongo.backend.infrastructure.client

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty
import org.springframework.stereotype.Component
import org.springframework.web.reactive.function.client.WebClient
import reactor.core.publisher.Mono

@Component
class KanjiApiClient(private val webClient: WebClient = WebClient.create("https://kanjiapi.dev")) {

    fun getKanji(character: String): Mono<KanjiApiResponse> {
        return webClient.get()
            .uri("/api/v1/kanji/{character}", character)
            .retrieve()
            .bodyToMono(KanjiApiResponse::class.java)
            .onErrorReturn(KanjiApiResponse())
    }

    fun getKanjiByGrade(grade: Int): Mono<List<String>> {
        return webClient.get()
            .uri("/api/v1/kanji/grade-{grade}", grade)
            .retrieve()
            .bodyToFlux(String::class.java)
            .collectList()
            .onErrorReturn(emptyList())
    }
}

@JsonIgnoreProperties(ignoreUnknown = true)
data class KanjiApiResponse(
    val kanji: String = "",
    val grade: Int? = null,
    @JsonProperty("stroke_count") val strokeCount: Int = 0,
    val meanings: List<String> = emptyList(),
    @JsonProperty("kun_readings") val kunReadings: List<String> = emptyList(),
    @JsonProperty("on_readings") val onReadings: List<String> = emptyList(),
    @JsonProperty("name_readings") val nameReadings: List<String> = emptyList(),
    val jlpt: Int? = null,
    val unicode: String = "",
    @JsonProperty("heisig_en") val heisigEn: String? = null
)
