import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenTestPage extends StatefulWidget {
  const TokenTestPage({super.key});

  @override
  State<TokenTestPage> createState() => _TokenTestPageState();
}

class _TokenTestPageState extends State<TokenTestPage> {
  String _result = 'Ready to test';
  bool _isLoading = false;

  Future<void> _checkToken() async {
    setState(() {
      _isLoading = true;
      _result = 'Checking token...';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        setState(() {
          _result = 'NO TOKEN FOUND!\nUser might not be logged in.';
          _isLoading = false;
        });
        return;
      }

      // Try to decode token
      final parts = token.split('.');
      if (parts.length != 3) {
        setState(() {
          _result = 'INVALID TOKEN FORMAT!\nToken: ${token.substring(0, 50)}...';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _result = 'TOKEN FOUND!\n'
            'Length: ${token.length}\n'
            'Parts: ${parts.length}\n'
            'First 50 chars: ${token.substring(0, 50)}...\n'
            'Last 20 chars: ...${token.substring(token.length - 20)}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'ERROR: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _setTestToken() async {
    setState(() {
      _isLoading = true;
      _result = 'Setting test token...';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      const testToken = 'eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJ0ZXN0QGV4YW1wbGUuY29tIiwiaWF0IjoxNzUzMDc4Nzc4LCJleHAiOjE3NTU2NzA3Nzh9.nrIP-1zb70Qj2ok4Hwj64w2ke9LuKOj4THSM7iog4HUpXEKXJlD1_gdLwPraRhos';
      
      await prefs.setString('auth_token', testToken);
      
      setState(() {
        _result = 'TEST TOKEN SET!\nNow you can test progress saving.';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'ERROR SETTING TOKEN: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Token Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Token Authentication Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _result,
                style: const TextStyle(fontSize: 14, fontFamily: 'Courier'),
              ),
            ),
            const SizedBox(height: 32),
            if (_isLoading) ...[
              const CircularProgressIndicator(),
            ] else ...[
              ElevatedButton(
                onPressed: _checkToken,
                child: const Text('Check Current Token'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _setTestToken,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Set Test Token'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
