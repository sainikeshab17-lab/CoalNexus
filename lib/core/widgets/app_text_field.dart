import 'package:flutter/material.dart';
import 'package:coalnexus/core/theme/app_radius.dart';

class AppTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}
