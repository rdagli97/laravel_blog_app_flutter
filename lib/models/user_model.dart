class UserModel {
  int? id;
  String? name;
  String? image;
  String? email;
  String? token;

  UserModel({
    this.id,
    this.name,
    this.image,
    this.email,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id'],
      name: json['user']['name'],
      image: json['user']['image'],
      email: json['user']['email'],
      token: json['token'],
    );
  }
}
