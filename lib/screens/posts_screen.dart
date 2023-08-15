import 'package:flutter/material.dart';
import 'package:laravel_my_blog_app/consts/global_variables.dart';
import 'package:laravel_my_blog_app/consts/palette.dart';
import 'package:laravel_my_blog_app/models/api_response.dart';
import 'package:laravel_my_blog_app/models/post_model.dart';
import 'package:laravel_my_blog_app/models/user_model.dart';
import 'package:laravel_my_blog_app/screens/comment_screen.dart';
import 'package:laravel_my_blog_app/screens/create_post_screen.dart';
import 'package:laravel_my_blog_app/screens/login_screen.dart';
import 'package:laravel_my_blog_app/services/like_service.dart';
import 'package:laravel_my_blog_app/services/post_service.dart';
import 'package:laravel_my_blog_app/services/user_service.dart';
import 'package:laravel_my_blog_app/utils/navigate_to.dart';
import 'package:laravel_my_blog_app/utils/show_error_message.dart';
import 'package:laravel_my_blog_app/widgets/container_post.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<dynamic> _postList = [];
  int userId = 0;
  bool _isLoading = false;
  UserModel? user;

  // get all posts
  Future<void> retrievePosts() async {
    setState(() {
      _isLoading = true;
    });
    userId = await getUserId();
    ApiResponse response = await getPosts();
    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;
      });
    } else if (response.error == unauthorized) {
      logoutAndPushLogin();
    } else {
      showError('${response.error}');
    }
    setState(() {
      _isLoading = false;
    });
  }

  // post like / dislike

  Future<void> _handleLikeOrDislike(int postId) async {
    ApiResponse response = await likeOrUnlike(postId);

    if (response.error == null) {
      retrievePosts();
    } else if (response.error == unauthorized) {
      logoutAndPushLogin();
    } else {
      showError('${response.error}');
    }
  }

  // post delete
  Future<void> _handleDeletePost(int postId) async {
    ApiResponse response = await deletePost(postId);

    if (response.error == null) {
      retrievePosts();
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
    retrievePosts();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: () {
              return retrievePosts();
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              itemCount: _postList.length,
              itemBuilder: (context, index) {
                PostModel post = _postList[index];
                return ContainerPost(
                  ppUrl: '${user!.image}',
                  username: '${post.user!.name}',
                  body: '${post.body}',
                  likeCount: post.likesCount,
                  commentCount: post.commentCount,
                  likeIcon: post.selfLiked == true
                      ? Icon(
                          Icons.favorite,
                          color: darkBlue,
                        )
                      : const Icon(Icons.favorite_border),
                  likeClick: () {
                    _handleLikeOrDislike(post.id ?? 0);
                  },
                  commentClick: () {
                    pushTo(
                      context,
                      CommentScreen(
                        postId: post.id,
                      ),
                    );
                  },
                  onSelected: (value) {
                    if (value == 'edit' && post.user!.id == userId) {
                      // edit
                      pushTo(
                        context,
                        CreatePostScreen(
                          postModel: post,
                          title: 'Edit post',
                        ),
                      );
                    } else {
                      if (post.user!.id == userId) {
                        // delete
                        _handleDeletePost(post.id ?? 0);
                      }
                    }
                  },
                );
              },
            ),
          );
  }
}
