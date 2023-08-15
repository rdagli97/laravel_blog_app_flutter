import 'package:laravel_my_blog_app/models/user_model.dart';

class PostModel {
  int? id;
  String? body;
  int? likesCount;
  int? commentCount;
  UserModel? user;
  bool? selfLiked;

  PostModel({
    this.id,
    this.body,
    this.commentCount,
    this.likesCount,
    this.user,
    this.selfLiked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      body: json['body'],
      likesCount: json['likes_count'],
      commentCount: json['comments_count'],
      selfLiked: json['likes'].length > 0,
      user: UserModel(
        id: json['user']['id'],
        name: json['user']['name'],
        image: json['user']['image'],
      ),
    );
  }
}
