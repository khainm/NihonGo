import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/auth_header.dart';
import '../widgets/register_form.dart';
import '../widgets/auth_footer.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/navigation_utils.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../core/di/injection_container.dart' as di;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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
      create: (context) => di.sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.registerSuccess),
                duration: Duration(seconds: 2),
              ),
            );
            // Sau khi đăng ký thành công, chuyển đến trang đăng nhập
            Future.delayed(const Duration(milliseconds: 1000), () {
              if (mounted) {
                NavigationUtils.navigateToLogin(context);
              }
            });
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${AppStrings.error}: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            body: AppLoadingOverlay(
              isLoading: state is AuthLoading,
              loadingMessage: 'Đang đăng ký...',
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      AuthHeader(
                        title: AppStrings.registerTitle,
                        subtitle: AppStrings.registerSubtitle,
                        iconAsset: 'assets/images/flower.png',
                      ),
                      AppTheme.verticalSpaceExtraLarge,
                      
                      // Form
                      RegisterForm(
                        nameController: _nameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        formKey: _formKey,
                      ),
                      AppTheme.verticalSpaceLarge,
                      
                      // Register Button
                      AppButton(
                        text: AppStrings.registerButton,
                        isLoading: state is AuthLoading,
                        onPressed: state is AuthLoading 
                          ? null 
                          : () => _handleRegister(context),
                      ),
                      AppTheme.verticalSpaceExtraLarge,
                      
                      // Footer
                      AuthFooter(
                        questionText: AppStrings.haveAccount,
                        actionText: AppStrings.loginButton,
                        onActionTap: () {
                          NavigationUtils.navigateToLogin(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleRegister(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        RegisterUserEvent(
          name: _nameController.text.isNotEmpty 
            ? _nameController.text 
            : null,
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }
}
