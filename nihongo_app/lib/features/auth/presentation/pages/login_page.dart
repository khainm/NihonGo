import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_footer.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/navigation_utils.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_form_field.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../core/di/injection_container.dart' as di;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                content: Text(AppStrings.loginSuccess),
                duration: Duration(seconds: 2),
              ),
            );
            // Sau khi đăng nhập thành công, chuyển đến trang home với hiệu ứng
            Future.delayed(const Duration(milliseconds: 1000), () {
              if (mounted) {
                NavigationUtils.navigateToHome(context);
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
              loadingMessage: 'Đang đăng nhập...',
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      AuthHeader(
                        title: AppStrings.loginTitle,
                        subtitle: AppStrings.loginSubtitle,
                        iconAsset: 'assets/images/flower.png',
                      ),
                      AppTheme.verticalSpaceExtraLarge,
                      
                      // Form
                      _buildLoginForm(),
                      AppTheme.verticalSpaceLarge,
                      
                      // Login Button
                      AppButton(
                        text: AppStrings.loginButton,
                        isLoading: state is AuthLoading,
                        onPressed: state is AuthLoading 
                          ? null 
                          : () => _handleLogin(context),
                      ),
                      AppTheme.verticalSpaceMedium,
                      
                      // Forgot Password
                      Center(
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implement forgot password
                          },
                          child: const Text(
                            AppStrings.forgotPassword,
                            style: AppTheme.linkTextStyle,
                          ),
                        ),
                      ),
                      AppTheme.verticalSpaceExtraLarge,
                      
                      // Footer
                      AuthFooter(
                        questionText: AppStrings.noAccount,
                        actionText: AppStrings.registerButton,
                        onActionTap: () {
                          NavigationUtils.navigateToRegister(context);
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

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.getCardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextFormField(
              label: AppStrings.emailLabel,
              hintText: AppStrings.loginEmailPlaceholder,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
              isRequired: true,
              validator: Validators.validateEmail,
            ),
            AppTheme.verticalSpaceMedium,
            AppTextFormField(
              label: AppStrings.passwordLabel,
              hintText: AppStrings.loginPasswordPlaceholder,
              controller: _passwordController,
              prefixIcon: const Icon(Icons.lock_outline),
              isPassword: true,
              isRequired: true,
              validator: Validators.validatePassword,
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        LoginUserEvent(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }
}
