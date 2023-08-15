import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final bool isCircle;
  final Color? color;
  final Widget child;
  final Function()? onTap;
  const CircleIconButton({
    super.key,
    required this.isCircle,
    required this.color,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius:
              isCircle ? BorderRadius.circular(40) : BorderRadius.circular(20),
          color: color,
        ),
        child: child,
      ),
    );
  }
}
