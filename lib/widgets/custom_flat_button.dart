import 'package:flutter/material.dart';
import 'package:laravel_my_blog_app/consts/palette.dart';
import 'package:laravel_my_blog_app/widgets/custom_text.dart';

class CustomFlatButton extends StatelessWidget {
  final Function()? onTap;
  final Color? color;
  final String text;
  final double? width;

  const CustomFlatButton({
    super.key,
    required this.color,
    required this.onTap,
    required this.text,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Center(
          child: CustomText(
            text: text,
            fontWeight: FontWeight.bold,
            color: white,
          ),
        ),
      ),
    );
  }
}
