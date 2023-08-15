import 'package:flutter/material.dart';
import 'package:laravel_my_blog_app/consts/global_variables.dart';
import 'package:laravel_my_blog_app/consts/palette.dart';
import 'package:laravel_my_blog_app/models/api_response.dart';
import 'package:laravel_my_blog_app/models/comment_model.dart';
import 'package:laravel_my_blog_app/models/user_model.dart';
import 'package:laravel_my_blog_app/screens/login_screen.dart';
import 'package:laravel_my_blog_app/services/comment_service.dart';
import 'package:laravel_my_blog_app/services/user_service.dart';
import 'package:laravel_my_blog_app/utils/navigate_to.dart';
import 'package:laravel_my_blog_app/utils/show_error_message.dart';
import 'package:laravel_my_blog_app/widgets/circle_icon_button.dart';
import 'package:laravel_my_blog_app/widgets/custom_comment.dart';
import 'package:laravel_my_blog_app/widgets/custom_text_form_field.dart';

class CommentScreen extends StatefulWidget {
  final int? postId;
  const CommentScreen({
    super.key,
    this.postId,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List<dynamic> _commentList = [];
  final bool _isLoading = false;
  int userId = 0;
  int _editCommentId = 0;
  UserModel? user;

  // get all comment of this post
  Future<void> _getComments() async {
    userId = await getUserId();
    ApiResponse response = await getComments(widget.postId ?? 0);

    if (response.error == null) {
      setState(() {
        _commentList = response.data as List<dynamic>;
      });
    } else if (response.error == unauthorized) {
      logoutAndPushLogin();
    } else {
      showError('${response.error}');
    }
  }

  // create comment
  Future<void> _createComment() async {
    ApiResponse response =
        await createComment(widget.postId ?? 0, commentController.text);

    if (response.error == null) {
      commentController.clear();
      _getComments();
    } else if (response.error == unauthorized) {
      logoutAndPushLogin();
    } else {
      showError('${response.error}');
    }
  }

  // edit comment
  Future<void> _editComment() async {
    ApiResponse response =
        await editComment(_editCommentId, commentController.text);

    if (response.error == null) {
      _editCommentId = 0;
      commentController.clear();
      _getComments();
    } else if (response.error == unauthorized) {
      logoutAndPushLogin();
    } else {
      showError('${response.error}');
    }
  }

  // delete comment
  Future<void> _deleteComment(int commentId) async {
    ApiResponse response = ApiResponse();

    if (response.error == null) {
      _getComments();
    } else if (response.error == unauthorized) {
      logoutAndPushLogin();
    } else {
      showError('${response.error}');
    }
  }

  // get user detail
  Future<void> getUser() async {
    ApiResponse response = await getUserDetail();

    if (response.error == null) {
      setState(() {
        user = response.data as UserModel;
      });
    } else if (response.error == unauthorized) {
      logoutAndPushLogin();
    } else {
      showError('${response.error}');
    }
  }

  void showError(String text) {
    showErrorMessage(context, text);
  }

  void logoutAndPushLogin() {
    logout().then((value) => {
          pushReplacementTo(
            context,
            const LoginScreen(),
          ),
        });
  }

  @override
  void initState() {
    _getComments();
    getUser();
    super.initState();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () {
                      return _getComments();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 15),
                      itemCount: _commentList.length,
                      itemBuilder: (context, index) {
                        CommentModel comment = _commentList[index];
                        return CustomComment(
                          ppUrl: '${user!.image}',
                          name: '${comment.user!.name}',
                          comment: '${comment.comment}',
                          onSelected: (value) {
                            if (value == 'edit' && comment.user!.id != userId) {
                              // edit
                              setState(() {
                                _editCommentId = comment.id ?? 0;
                                commentController.text = comment.comment ?? '';
                              });
                            } else {
                              if (comment.user!.id != userId) {
                                // delete
                                _deleteComment(comment.id ?? 0);
                              }
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // comment textfield
                      Form(
                        key: formKey,
                        child: Expanded(
                          child: CustomTextFormField(
                            controller: commentController,
                            keyboardType: TextInputType.text,
                            labelText: 'Send comment',
                            validator: (val) => val!.isEmpty
                                ? 'There is nothing to send'
                                : null,
                          ),
                        ),
                      ),
                      // send button
                      CircleIconButton(
                        isCircle: false,
                        color: skyBlue,
                        child: const Icon(Icons.arrow_circle_up_rounded),
                        onTap: () {
                          if (formKey.currentState!.validate() &&
                              _editCommentId > 0) {
                            _editComment();
                          } else {
                            _createComment();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
