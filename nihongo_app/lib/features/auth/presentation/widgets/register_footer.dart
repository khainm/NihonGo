import 'package:flutter/material.dart';

class RegisterFooter extends StatelessWidget {
  final VoidCallback? onLoginTap;
  const RegisterFooter({super.key, this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Đã có tài khoản? '),
        GestureDetector(
          onTap: onLoginTap,
          child: const Text(
            'Đăng nhập',
            style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
} 