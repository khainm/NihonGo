# Code Refactoring - Clean Architecture Implementation

## Tổng quan

Dự án đã được refactor để tuân theo các nguyên tắc Clean Architecture và chia nhỏ code để dễ bảo trì hơn. Dưới đây là các thay đổi chính:

## Cấu trúc mới

### 1. Core Layer
- **`core/theme/app_theme.dart`**: Tập trung tất cả theme constants, colors, text styles
- **`core/utils/validators.dart`**: Tách biệt logic validation
- **`core/utils/error_handler.dart`**: Xử lý lỗi tập trung
- **`core/constants/`**: Các constants được chia nhỏ thành các file riêng biệt

### 2. Shared Widgets
- **`shared/widgets/app_button.dart`**: Button component tái sử dụng
- **`shared/widgets/app_text_form_field.dart`**: Text input component tái sử dụng  
- **`shared/widgets/app_loading.dart`**: Loading indicators

### 3. Feature-specific Widgets
- **`features/auth/presentation/widgets/auth_header.dart`**: Header cho auth pages
- **`features/auth/presentation/widgets/auth_footer.dart`**: Footer cho auth pages
- **`features/auth/presentation/widgets/register_form.dart`**: Form đăng ký đã refactor

### 4. Pages mới
- **`register_page_new.dart`**: Trang đăng ký sử dụng widgets mới
- **`login_page_new.dart`**: Trang đăng nhập sử dụng widgets mới

## Cách sử dụng

### AppButton
```dart
AppButton(
  text: 'Đăng ký',
  onPressed: () => handleSubmit(),
  isLoading: isSubmitting,
  type: ButtonType.primary,
)
```

### AppTextFormField
```dart
AppTextFormField(
  label: 'Email',
  hintText: 'example@email.com',
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
  isRequired: true,
  isPassword: false,
  validator: Validators.validateEmail,
  prefixIcon: Icon(Icons.email),
)
```

### AuthHeader
```dart
AuthHeader(
  title: 'Đăng ký tài khoản',
  subtitle: 'Bắt đầu hành trình học tiếng Nhật',
  iconAsset: 'assets/images/flower.png',
)
```

### Theme Usage
```dart
// Spacing
AppTheme.verticalSpaceSmall    // 8px
AppTheme.verticalSpaceMedium   // 16px
AppTheme.verticalSpaceLarge    // 24px
AppTheme.verticalSpaceExtraLarge // 32px

// Colors
AppTheme.primaryColor
AppTheme.backgroundColor
AppTheme.textColor

// Text Styles
AppTheme.titleTextStyle
AppTheme.subtitleTextStyle
AppTheme.labelTextStyle
```

### Validators
```dart
// Email validation
validator: Validators.validateEmail

// Password validation
validator: Validators.validatePassword

// Password confirmation
validator: (value) => Validators.validatePasswordConfirmation(value, originalPassword)

// Name validation (optional field)
validator: Validators.validateName
```

### Error Handling
```dart
// Show error snackbar
ErrorHandler.showError(context, 'Có lỗi xảy ra');

// Show success snackbar
ErrorHandler.showSuccess(context, 'Thành công');

// Convert error to user-friendly message
String message = ErrorHandler.getErrorMessage(error);
```

## Cập nhật DI Container

NetworkService đã được đăng ký trong DI container:

```dart
// Core
sl.registerLazySingleton(() => NetworkService(client: sl()));
sl.registerLazySingleton(() => http.Client());

// Data sources now use NetworkService
sl.registerLazySingleton<AuthRemoteDataSource>(
  () => AuthRemoteDataSourceImpl(networkService: sl()),
);
```

## Migration từ code cũ

1. **Thay thế `main.dart`** bằng `main_new.dart`
2. **Thay thế `register_page.dart`** bằng `register_page_new.dart`  
3. **Thay thế `login_page.dart`** bằng `login_page_new.dart`
4. **Import các widget mới** thay vì hardcode UI
5. **Sử dụng constants** từ `AppTheme`, `AppStrings`, `AppConstants`

## Lợi ích

1. **Tái sử dụng code**: Widgets có thể dùng cho nhiều màn hình
2. **Dễ bảo trì**: Logic tách biệt, dễ debug và update
3. **Consistency**: UI nhất quán trên toàn app
4. **Testing**: Dễ viết unit test cho từng component
5. **Scalability**: Dễ mở rộng và thêm tính năng mới

## Next Steps

1. Áp dụng pattern tương tự cho các features khác
2. Tạo thêm shared widgets (Card, Dialog, etc.)
3. Implement internationalization (i18n)
4. Thêm dark mode support
5. Viết unit tests cho các widgets mới
