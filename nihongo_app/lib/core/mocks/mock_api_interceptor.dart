import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:nihongo_app/shared/models/user.dart';

class MockApiInterceptor extends Interceptor {
  final Map<String, dynamic> _users = {};
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Giả lập độ trễ mạng
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Xử lý các endpoint khác nhau
    if (options.path.contains('/auth/register')) {
      _handleRegister(options, handler);
    } else if (options.path.contains('/auth/login')) {
      _handleLogin(options, handler);
    } else {
      // Nếu không có endpoint nào khớp, tiếp tục yêu cầu
      return super.onRequest(options, handler);
    }
  }
  
  void _handleRegister(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final data = options.data;
      final String email = data['email'];
      
      // Kiểm tra nếu email đã được đăng ký
      if (_users.containsKey(email)) {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 400,
              data: {
                'message': 'Email đã được đăng ký',
              },
            ),
          ),
        );
      }
      
      // Tạo người dùng mới
      final String userId = _generateUserId();
      final user = User(
        id: userId,
        name: data['name'],
        email: email,
        level: 'N5',
        joinedDate: DateTime.now(),
      );
      
      // Lưu vào database giả lập
      _users[email] = {
        'user': user.toJson(),
        'password': data['password'],
      };
      
      // Tạo token giả
      final String token = _generateToken();
      
      // Trả về response thành công
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 201,
          data: {
            'token': token,
            'user': user.toJson(),
          },
        ),
      );
    } catch (e) {
      return handler.reject(
        DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 500,
            data: {
              'message': 'Lỗi server: $e',
            },
          ),
        ),
      );
    }
  }
  
  void _handleLogin(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final data = options.data;
      final String email = data['email'];
      final String password = data['password'];
      
      // Kiểm tra nếu email tồn tại
      if (!_users.containsKey(email)) {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 400,
              data: {
                'message': 'Email không tồn tại',
              },
            ),
          ),
        );
      }
      
      // Kiểm tra mật khẩu
      if (_users[email]['password'] != password) {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 400,
              data: {
                'message': 'Mật khẩu không đúng',
              },
            ),
          ),
        );
      }
      
      // Tạo token giả
      final String token = _generateToken();
      
      // Trả về response thành công
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'token': token,
            'user': _users[email]['user'],
          },
        ),
      );
    } catch (e) {
      return handler.reject(
        DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 500,
            data: {
              'message': 'Lỗi server: $e',
            },
          ),
        ),
      );
    }
  }
  
  String _generateUserId() {
    return Random().nextInt(10000).toString();
  }
  
  String _generateToken() {
    final List<int> tokenBytes = List.generate(32, (_) => Random().nextInt(256));
    return base64Encode(tokenBytes);
  }
}
