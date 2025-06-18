import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ErrorHandler {
  /// Shows a snackbar with error message
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Shows a snackbar with success message
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Shows a dialog with error message
  static void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Maps network errors to user-friendly messages
  static String getErrorMessage(dynamic error) {
    if (error.toString().contains('SocketException')) {
      return 'Không có kết nối mạng. Vui lòng kiểm tra lại.';
    } else if (error.toString().contains('TimeoutException')) {
      return 'Kết nối quá chậm. Vui lòng thử lại.';
    } else if (error.toString().contains('401')) {
      return 'Thông tin đăng nhập không chính xác.';
    } else if (error.toString().contains('403')) {
      return 'Bạn không có quyền truy cập.';
    } else if (error.toString().contains('404')) {
      return 'Dịch vụ không tìm thấy.';
    } else if (error.toString().contains('500')) {
      return 'Lỗi máy chủ. Vui lòng thử lại sau.';
    } else {
      return 'Đã xảy ra lỗi. Vui lòng thử lại.';
    }
  }
}
