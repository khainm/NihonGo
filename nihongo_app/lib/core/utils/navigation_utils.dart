import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

class NavigationUtils {
  /// Điều hướng với hiệu ứng slide từ phải sang trái
  static void pushReplacementWithSlideTransition(
    BuildContext context,
    Widget page,
  ) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  /// Điều hướng với hiệu ứng fade
  static void pushReplacementWithFadeTransition(
    BuildContext context,
    Widget page,
  ) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  /// Điều hướng đến trang đăng nhập
  static void navigateToLogin(BuildContext context) {
    pushReplacementWithSlideTransition(
      context,
      const LoginPage(),
    );
  }

  /// Điều hướng đến trang đăng ký
  static void navigateToRegister(BuildContext context) {
    pushReplacementWithSlideTransition(
      context,
      const RegisterPage(),
    );
  }

  /// Điều hướng đến trang home
  static void navigateToHome(BuildContext context) {
    pushReplacementWithFadeTransition(
      context,
      const HomePage(),
    );
  }
}
