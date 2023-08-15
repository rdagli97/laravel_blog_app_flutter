import 'package:flutter/material.dart';
import 'package:laravel_my_blog_app/utils/add_space.dart';
import 'package:laravel_my_blog_app/widgets/custom_text.dart';
import 'package:laravel_my_blog_app/widgets/line.dart';

class CustomComment extends StatelessWidget {
  final String name;
  final String comment;
  final Function(String)? onSelected;
  final String ppUrl;
  const CustomComment({
    super.key,
    required this.name,
    required this.comment,
    required this.onSelected,
    required this.ppUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // pp
            CircleAvatar(
              backgroundImage: NetworkImage(ppUrl),
            ),
            AddSpace().addHorizontalSpace(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // name
                CustomText(
                  text: name,
                  fontWeight: FontWeight.bold,
                ),
                // body
                CustomText(text: comment),
              ],
            ),
            const Spacer(),
            // delete & edit button
            PopupMenuButton(
              itemBuilder: (context) => [
                // edit
                const PopupMenuItem(
                  value: 'edit',
                  child: CustomText(text: 'Edit'),
                ),
                // delete
                const PopupMenuItem(
                  value: 'delete',
                  child: CustomText(text: 'Delete'),
                ),
              ],
              onSelected: onSelected,
              child: const Icon(Icons.more_vert),
            ),
          ],
        ),
        AddSpace().addVerticalSpace(5),
        const LineHorizontal(),
      ],
    );
  }
}
