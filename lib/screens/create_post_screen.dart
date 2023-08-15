import 'package:flutter/material.dart';
import 'package:laravel_my_blog_app/consts/global_variables.dart';
import 'package:laravel_my_blog_app/consts/palette.dart';
import 'package:laravel_my_blog_app/models/api_response.dart';
import 'package:laravel_my_blog_app/models/post_model.dart';
import 'package:laravel_my_blog_app/screens/loading_screen.dart';
import 'package:laravel_my_blog_app/screens/login_screen.dart';
import 'package:laravel_my_blog_app/services/post_service.dart';
import 'package:laravel_my_blog_app/services/user_service.dart';
import 'package:laravel_my_blog_app/utils/navigate_to.dart';
import 'package:laravel_my_blog_app/utils/show_error_message.dart';
import 'package:laravel_my_blog_app/widgets/circle_icon_button.dart';
import 'package:laravel_my_blog_app/widgets/custom_text.dart';

class CreatePostScreen extends StatefulWidget {
  final PostModel? postModel;
  final String? title;
  const CreatePostScreen({
    super.key,
    this.postModel,
    this.title,
  });

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController bodyController = TextEditingController();
  bool _isLoading = false;

  // create post
  Future<void> _createPost() async {
    setState(() {
      _isLoading = true;
    });
    ApiResponse response = await createPost(bodyController.text);

    if (response.error == null) {
      pushReplacementToLoadingScreen();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            pushReplacementTo(
              context,
              const LoginScreen(),
            ),
          });
    } else {
      Builder(
        builder: (context) {
          showErrorMessage(context, '${response.error}');
          return const SizedBox.shrink();
        },
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  // edit post
  Future<void> _editPost(int postId) async {
    setState(() {
      _isLoading = true;
    });
    ApiResponse response = await editPost(postId, bodyController.text);

    if (response.error == null) {
      popBack();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            pushReplacementTo(
              context,
              const LoginScreen(),
            ),
          });
    } else {
      Builder(
        builder: (context) {
          showErrorMessage(context, '${response.error}');
          return const SizedBox.shrink();
        },
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  // response.error == null
  void pushReplacementToLoadingScreen() {
    pushReplacementTo(
      context,
      const LoadingScreen(),
    );
  }

  // response.error == null
  void popBack() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    if (widget.postModel != null) {
      bodyController.text = widget.postModel!.body ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: '${widget.title}'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                // body textfield
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: bodyController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 9,
                      validator: (value) =>
                          value!.isEmpty ? 'Post body required' : null,
                      decoration: InputDecoration(
                        hintText: "Post body...",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: skyBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // post button
                CircleIconButton(
                  isCircle: true,
                  color: darkBlue,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      if (widget.postModel == null) {
                        _createPost();
                      } else {
                        _editPost(widget.postModel!.id ?? 0);
                      }
                    }
                  },
                  child: Center(
                    child: CustomText(
                      text:
                          widget.postModel == null ? 'Share Post' : 'Edit Post',
                      fontWeight: FontWeight.bold,
                      color: white,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
