import 'package:laravel_my_blog_app/models/user_model.dart';

class CommentModel {
  int? id;
  String? comment;
  UserModel? user;

  CommentModel({
    this.id,
    this.comment,
    this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      comment: json['comment'],
      user: UserModel(
        id: json['user']['id'],
        name: json['user']['name'],
        image: json['user']['image'],
      ),
    );
  }
}
