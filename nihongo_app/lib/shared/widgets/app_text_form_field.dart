import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AppTextFormField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool isRequired;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final bool enabled;

  const AppTextFormField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.isRequired = false,
    this.validator,
    this.prefixIcon,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: AppTheme.labelTextStyle,
            ),
            if (widget.isRequired)
              const Text(
                ' *',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
          ],
        ),
        AppTheme.verticalSpaceSmall,
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obscureText : false,
          enabled: widget.enabled,
          decoration: AppTheme.getInputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
