package com.nihongo.backend.presentation.dto.request

import com.fasterxml.jackson.annotation.JsonProperty

data class JlptProgressUpdateRequest(
    @JsonProperty("user_id")
    val userId: String? = null, // Optional user ID for non-authenticated requests
    @JsonProperty("jlpt_level")
    val jlptLevel: String? = null, // "N5", "N4", etc. - Optional, derived from wordId
    @JsonProperty("lesson_id")
    val lessonId: String? = null, // "n5_bai_1" - Optional, derived from wordId
    @JsonProperty("word_id")
    val wordId: String,
    @JsonProperty("is_learned")
    val isLearned: Boolean
)
