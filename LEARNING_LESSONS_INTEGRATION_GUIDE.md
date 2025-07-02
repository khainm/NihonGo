# Learning Lessons API Integration Guide

## Tổng quan
Hệ thống Learning Lessons đã được kết nối giữa backend (Kotlin Spring Boot) và frontend (Flutter) để cung cấp các bài học có cấu trúc cho việc học tiếng Nhật.

## Backend APIs

### 1. Learning Lesson Controller
- **Base URL**: `/api/learning/lessons`
- **Endpoints**:
  - `GET /type/{type}` - Lấy danh sách bài học theo loại (VOCABULARY, GRAMMAR, KANJI, LISTENING)
  - `GET /{lessonId}` - Lấy chi tiết bài học
  - `POST /progress/{userId}` - Cập nhật tiến độ học
  - `GET /progress/{userId}/summary` - Lấy tổng quan tiến độ
  - `GET /search` - Tìm kiếm bài học
  - `GET /types` - Lấy danh sách loại bài học
  - `GET /difficulties` - Lấy danh sách độ khó

### 2. Dữ liệu được tự động tạo
Backend sẽ tự động tạo dữ liệu mẫu khi:
- Không có bài học nào cho level/type được yêu cầu
- Dữ liệu sẽ được lấy từ các service hiện tại (VocabularyService, GrammarService, etc.)

## Frontend Integration

### 1. Các file đã được tạo:

#### Vocabulary:
- `vocabulary/data/datasources/vocabulary_lesson_remote_datasource.dart`
- `vocabulary/data/repositories/vocabulary_repository_impl.dart`
- `vocabulary/data/models/vocabulary_lesson_model.dart`
- `vocabulary/domain/usecases/get_vocabulary_lessons_with_user.dart`

#### Grammar:
- `grammar/data/datasources/grammar_lesson_remote_datasource.dart`
- `grammar/data/repositories/grammar_repository_impl.dart`
- `grammar/data/models/grammar_lesson_model.dart`
- `grammar/domain/usecases/get_grammar_lessons_with_user.dart`

#### Kanji:
- `kanji/data/datasources/kanji_lesson_remote_datasource.dart`
- `kanji/data/repositories/kanji_repository_impl.dart`
- `kanji/data/models/kanji_lesson_model.dart`
- `kanji/domain/usecases/get_kanji_lessons_with_user.dart`

#### Listening:
- `listening/data/datasources/listening_lesson_remote_datasource.dart`
- `listening/data/repositories/listening_repository_impl.dart`
- `listening/data/models/listening_lesson_model.dart`
- `listening/domain/usecases/get_listening_lessons_with_user.dart`

### 2. Cách sử dụng trong Flutter:

```dart
// Import API
import 'package:your_app/features/learning_lessons/learning_lessons_api.dart';
import 'package:http/http.dart' as http;

// Khởi tạo dependencies
final client = http.Client();
final vocabularyDataSource = VocabularyLessonRemoteDataSourceImpl(client: client);
final vocabularyRepository = VocabularyRepositoryImpl(remoteDataSource: vocabularyDataSource);
final getVocabularyLessons = GetVocabularyLessonsWithUser(vocabularyRepository);

// Sử dụng
try {
  final lessons = await getVocabularyLessons.call('5', userId: 'user123');
  // Xử lý dữ liệu lessons
} catch (e) {
  // Xử lý lỗi
}
```

## Cách chạy và test

### 1. Backend:
```bash
cd backend
./gradlew bootRun
```

### 2. Test APIs:
- Lấy vocabulary lessons: `GET http://localhost:8080/api/learning/lessons/type/VOCABULARY?jlptLevel=5`
- Lấy grammar lessons: `GET http://localhost:8080/api/learning/lessons/type/GRAMMAR?jlptLevel=5`
- Lấy chi tiết lesson: `GET http://localhost:8080/api/learning/lessons/{lessonId}`
- Cập nhật tiến độ: `POST http://localhost:8080/api/learning/lessons/progress/{userId}`

### 3. Frontend:
```bash
cd nihongo_app
flutter pub get
flutter run
```

## Cấu trúc dữ liệu

### Learning Lesson Response:
```json
{
  "id": "lesson_id",
  "title": "Tên bài học",
  "description": "Mô tả bài học",
  "type": "VOCABULARY|GRAMMAR|KANJI|LISTENING",
  "jlptLevel": 5,
  "category": "greeting",
  "totalItems": 20,
  "estimatedTimeMinutes": 30,
  "difficulty": "BEGINNER",
  "tags": ["greeting", "basic"],
  "prerequisites": [],
  "isActive": true,
  "progress": {
    "completedItems": 5,
    "totalItems": 20,
    "progressPercentage": 25.0,
    "isCompleted": false
  }
}
```

### Update Progress Request:
```json
{
  "lessonId": "lesson_id",
  "itemId": "vocabulary_id",
  "isLearned": true
}
```

## Tính năng chính

1. **Bài học có cấu trúc**: Mỗi bài học có tiến độ, thời gian ước tính, độ khó
2. **Theo dõi tiến độ**: Cập nhật tiến độ học theo từng item
3. **Phân loại theo JLPT**: Bài học được phân theo level N1-N5
4. **Tìm kiếm và lọc**: Tìm kiếm theo từ khóa, lọc theo category
5. **Dashboard tiến độ**: Tổng quan tiến độ học của user
6. **Cache**: Sử dụng Spring Cache để tối ưu performance

## Ghi chú quan trọng

1. **User Context**: Các API cần userId để theo dõi tiến độ cá nhân
2. **Base URL**: Cần cấu hình đúng base URL trong datasource
3. **Error Handling**: Đã có error handling cơ bản, cần mở rộng theo yêu cầu
4. **Authentication**: Chưa implement authentication, cần thêm nếu cần
5. **Offline Support**: Chưa có offline cache, có thể thêm SharedPreferences/SQLite

## Các bước tiếp theo

1. Cập nhật UI để sử dụng API mới
2. Thêm authentication nếu cần
3. Implement offline support
4. Thêm analytics và tracking
5. Optimize performance với pagination
6. Thêm unit tests và integration tests
