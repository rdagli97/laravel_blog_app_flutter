import 'package:flutter/material.dart';
import 'package:laravel_my_blog_app/consts/global_variables.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String labelText;
  final bool? isPass;
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.labelText,
    required this.validator,
    this.isPass,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPass ?? false,
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: kInputDecoration(labelText),
    );
  }
}
