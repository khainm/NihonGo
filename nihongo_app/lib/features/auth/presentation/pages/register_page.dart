import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/register_header.dart';
import '../widgets/register_form.dart';
import '../widgets/register_button.dart';
import '../widgets/register_footer.dart';
import '../bloc/auth_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'package:nihongo_app/core/network/api_client.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        AuthRepository(
          ApiClient(),
        ),
      ),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Điều hướng đến màn hình Home sau khi đăng ký thành công
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đăng ký thành công!')),
            );
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthFailure) {
            // Hiển thị thông báo lỗi
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const RegisterHeader(),
                    const SizedBox(height: 32),
                    RegisterForm(
                      nameController: _nameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      formKey: _formKey,
                    ),
                    const SizedBox(height: 24),
                    RegisterButton(
                      onPressed: state is AuthLoading 
                        ? null 
                        : () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<AuthBloc>(context).add(
                                RegisterButtonPressed(
                                  name: _nameController.text.isNotEmpty 
                                    ? _nameController.text 
                                    : null,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ),
                              );
                            }
                          },
                    ),
                    if (state is AuthLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    const SizedBox(height: 32),
                    RegisterFooter(onLoginTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}