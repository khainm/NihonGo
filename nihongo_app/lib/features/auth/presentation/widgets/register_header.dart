import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 40),
        Center(
          child: Image(
            image: AssetImage('assets/icons/cherry_blossom.png'),
            height: 56,
            width: 56,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Đăng ký tài khoản',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Bắt đầu hành trình học tiếng Nhật của bạn',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF7B7B7B),
          ),
        ),
      ],
    );
  }
} 