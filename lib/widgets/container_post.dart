import 'package:flutter/material.dart';
import 'package:laravel_my_blog_app/utils/add_space.dart';
import 'package:laravel_my_blog_app/widgets/custom_text.dart';
import 'package:laravel_my_blog_app/widgets/line.dart';

class ContainerPost extends StatelessWidget {
  final String username;
  final String body;
  final int? likeCount;
  final int? commentCount;
  final Function()? likeClick;
  final Function()? commentClick;
  final Widget likeIcon;
  final Function(String)? onSelected;
  final String ppUrl;
  const ContainerPost({
    super.key,
    required this.username,
    required this.body,
    required this.onSelected,
    required this.likeClick,
    required this.commentClick,
    required this.likeIcon,
    required this.likeCount,
    required this.commentCount,
    required this.ppUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LineHorizontal(),
        AddSpace().addVerticalSpace(20),
        Row(
          children: [
            AddSpace().addHorizontalSpace(10),
            // pp
            CircleAvatar(
              backgroundImage: NetworkImage(ppUrl),
            ),
            AddSpace().addHorizontalSpace(20),
            // username
            CustomText(
              text: username,
              fontWeight: FontWeight.bold,
            ),
            const Spacer(),
            // dropdown menu
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
        AddSpace().addVerticalSpace(10),
        Row(
          children: [
            AddSpace().addHorizontalSpace(70),
            CustomText(text: body),
          ],
        ),
        AddSpace().addVerticalSpace(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // like button
            IconButton(onPressed: likeClick, icon: likeIcon),
            // like count
            CustomText(text: '${likeCount ?? 0}'),
            AddSpace().addHorizontalSpace(20),
            // comment button
            IconButton(
              onPressed: commentClick,
              icon: const Icon(Icons.mode_comment_outlined),
            ),
            // comment count
            CustomText(text: '${commentCount ?? 0}'),
          ],
        ),
        AddSpace().addVerticalSpace(10),
      ],
    );
  }
}
