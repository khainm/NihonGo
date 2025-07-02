# Grammar Module Organization

## Phân biệt giữa Grammar Lessons và Grammar Test

### 1. **Learning Lessons - Grammar** (`/features/learning_lessons/grammar/`)
- **Mục đích**: Học ngữ pháp cơ bản từng bước
- **Đối tượng**: Người học muốn nắm vững kiến thức ngữ pháp
- **Tính năng**:
  - Học chi tiết từng điểm ngữ pháp
  - Giải thích cách sử dụng, ví dụ
  - Luyện tập interactive với nhiều dạng bài
  - Theo dõi tiến độ học tập

### 2. **JLPT Practice Test - Grammar** (`/features/jlpt_practice_test/presentation/grammar_test/`)
- **Mục đích**: Luyện thi JLPT với đề thi thực tế
- **Đối tượng**: Người chuẩn bị thi JLPT
- **Tính năng**:
  - Đề thi mô phỏng JLPT
  - Chấm điểm theo tiêu chuẩn JLPT
  - Phân tích kết quả thi
  - Không có tính năng học chi tiết

## Sự khác biệt về Model

### Learning Grammar Lesson
```dart
class GrammarLesson {
  final List<GrammarPoint> grammarPoints;  // Chi tiết từng điểm ngữ pháp
  final Duration estimatedTime;            // Thời gian học ước tính
  final String category;                   // Phân loại ngữ pháp
  // ... các thuộc tính khác cho việc học
}

class GrammarPoint {
  final String pattern;        // Mẫu ngữ pháp
  final String meaning;        // Nghĩa
  final String explanation;    // Giải thích chi tiết
  final List<GrammarExample> examples;  // Ví dụ
  // ... 
}
```

### JLPT Grammar Test
```dart
class GrammarLesson {
  final int totalPoints;       // Tổng số câu hỏi
  final int completedPoints;   // Số câu đã làm
  final String level;          // Cấp độ JLPT (N1, N2, ...)
  // Model đơn giản hơn, tập trung vào việc thi
}
```

## Navigation

### Level Detail Page
- **"Ngữ pháp"** → `LearningGrammar.GrammarLessonsPage` (Học ngữ pháp)
- **"Đề thi ngữ pháp JLPT"** → `JLPTGrammar.GrammarLessonsPage` (Luyện thi)

## Best Practices

1. **Không sử dụng chung components** giữa Learning và JLPT Test
2. **Import với alias** để tránh xung đột tên
3. **Đặt tên rõ ràng** để phân biệt mục đích sử dụng
4. **Tách biệt logic** học tập và luyện thi
