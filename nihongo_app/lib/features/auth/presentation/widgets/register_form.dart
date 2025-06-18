import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/app_text_form_field.dart';

class RegisterForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;

  const RegisterForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.getCardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextFormField(
              label: AppStrings.nameLabel,
              hintText: AppStrings.namePlaceholder,
              controller: widget.nameController,
              prefixIcon: const Icon(Icons.person_outline),
              validator: Validators.validateName,
            ),
            AppTheme.verticalSpaceMedium,
            AppTextFormField(
              label: AppStrings.emailLabel,
              hintText: AppStrings.emailPlaceholder,
              controller: widget.emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
              isRequired: true,
              validator: Validators.validateEmail,
            ),
            AppTheme.verticalSpaceMedium,
            AppTextFormField(
              label: AppStrings.passwordLabel,
              hintText: AppStrings.passwordPlaceholder,
              controller: widget.passwordController,
              prefixIcon: const Icon(Icons.lock_outline),
              isPassword: true,
              isRequired: true,
              validator: Validators.validatePassword,
            ),
            AppTheme.verticalSpaceMedium,
            AppTextFormField(
              label: AppStrings.confirmPasswordLabel,
              hintText: AppStrings.confirmPasswordPlaceholder,
              controller: widget.confirmPasswordController,
              prefixIcon: const Icon(Icons.lock_outline),
              isPassword: true,
              isRequired: true,
              validator: (value) => Validators.validatePasswordConfirmation(
                value,
                widget.passwordController.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
