import 'package:flutter/material.dart';
import 'package:laravel_my_blog_app/consts/palette.dart';

class LineHorizontal extends StatelessWidget {
  final Color? color;
  const LineHorizontal({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: color ?? darkBlue,
    );
  }
}
