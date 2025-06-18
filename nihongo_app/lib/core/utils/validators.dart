import '../constants/app_constants.dart';
import '../constants/app_strings.dart';

class Validators {
  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired;
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email không đúng định dạng';
    }
    
    return null;
  }
  
  /// Validates password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    
    if (value.length < AppConstants.passwordMinLength) {
      return AppStrings.passwordMinLength;
    }
    
    return null;
  }
  
  /// Validates password confirmation
  static String? validatePasswordConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }
    
    if (value != password) {
      return AppStrings.passwordMismatch;
    }
    
    return null;
  }
  
  /// Validates name (optional field)
  static String? validateName(String? value) {
    // Name is optional, so return null if empty
    if (value == null || value.isEmpty) {
      return null;
    }
    
    // If provided, check minimum length
    if (value.trim().length < 2) {
      return 'Tên phải có ít nhất 2 ký tự';
    }
    
    return null;
  }
  
  /// Generic required field validator
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập $fieldName';
    }
    return null;
  }
}
