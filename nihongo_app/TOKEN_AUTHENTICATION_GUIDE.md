# Tính năng Lưu trữ Token Đăng nhập

## Mô tả
Tính năng này cho phép ứng dụng lưu trữ token đăng nhập của người dùng và tự động đăng nhập khi mở lại ứng dụng, mà không cần người dùng phải nhập lại thông tin đăng nhập.

## Các tính năng chính

### 1. Lưu trữ Token tự động
- Khi người dùng đăng nhập hoặc đăng ký thành công, token sẽ được lưu trữ tự động vào SharedPreferences
- Thông tin được lưu trữ: Token, Email, Tên (nếu có)

### 2. Auto-login khi khởi động ứng dụng
- Khi mở ứng dụng, hệ thống sẽ kiểm tra xem có token đã lưu hay không
- Nếu có token hợp lệ, người dùng sẽ được chuyển trực tiếp đến màn hình chính
- Nếu không có token, người dùng sẽ được chuyển đến màn hình đăng nhập

### 3. Màn hình Splash
- Thêm màn hình Splash để kiểm tra trạng thái authentication khi khởi động
- Hiển thị logo và thông báo "Đang khởi tạo..." trong khi kiểm tra

### 4. Tính năng Đăng xuất
- Người dùng có thể đăng xuất từ trang Profile
- Khi đăng xuất, token sẽ bị xóa khỏi bộ nhớ
- Sau khi đăng xuất, người dùng sẽ được chuyển về màn hình đăng nhập

## Cách thức hoạt động

### AuthService
```dart
class AuthService {
  // Lưu thông tin đăng nhập
  static Future<void> saveAuthData({
    required String token,
    required String email,
    String? name,
  });
  
  // Xóa thông tin đăng nhập
  static Future<void> clearAuthData();
  
  // Kiểm tra trạng thái đăng nhập
  static bool isAuthenticated();
  
  // Lấy token
  static String? getToken();
}
```

### AuthBloc Events
- `CheckAuthenticationEvent`: Kiểm tra trạng thái đăng nhập khi khởi động
- `LoginUserEvent`: Đăng nhập người dùng
- `RegisterUserEvent`: Đăng ký người dùng mới  
- `LogoutEvent`: Đăng xuất người dùng

### AuthBloc States
- `AuthInitial`: Trạng thái khởi tạo
- `AuthLoading`: Đang xử lý
- `AuthAuthenticated`: Đã đăng nhập
- `AuthUnauthenticated`: Chưa đăng nhập
- `AuthError`: Có lỗi xảy ra

## Luồng hoạt động

1. **Khởi động ứng dụng**:
   - Hiển thị SplashScreen
   - Kiểm tra token đã lưu
   - Chuyển đến Home (nếu có token) hoặc Login (nếu không có token)

2. **Đăng nhập thành công**:
   - Lưu token, email, name vào SharedPreferences
   - Chuyển đến màn hình Home
   - Emit AuthAuthenticated state

3. **Đăng xuất**:
   - Hiển thị dialog xác nhận
   - Xóa token khỏi SharedPreferences
   - Chuyển về màn hình Login
   - Emit AuthUnauthenticated state

## Bảo mật
- Token được lưu trữ bằng SharedPreferences (an toàn cho mobile app)
- Token sẽ bị xóa khi người dùng đăng xuất
- Không lưu trữ mật khẩu

## Các file đã được cập nhật

1. **core/services/auth_service.dart**: Thêm logic lưu/xóa token
2. **features/auth/presentation/bloc/**: Thêm events và states mới
3. **features/auth/presentation/pages/splash_screen.dart**: Màn hình splash mới
4. **features/profile/presentation/pages/profile_page.dart**: Thêm tính năng đăng xuất
5. **features/auth/domain/entities/user.dart**: Thêm trường token
6. **features/auth/data/models/user_model.dart**: Cập nhật model
7. **main.dart**: Cập nhật initial route
8. **core/di/injection_container.dart**: Khởi tạo AuthService

## Cách sử dụng

### Đăng nhập lần đầu
1. Mở ứng dụng
2. Nhập thông tin đăng nhập
3. Token sẽ được lưu tự động

### Mở lại ứng dụng
1. Mở ứng dụng
2. Tự động chuyển đến màn hình chính (không cần đăng nhập lại)

### Đăng xuất
1. Vào trang Profile
2. Nhấn nút "Đăng xuất"
3. Xác nhận trong dialog
4. Tự động chuyển về màn hình đăng nhập
