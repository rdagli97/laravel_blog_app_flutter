import 'dart:convert';

import 'package:laravel_my_blog_app/consts/global_variables.dart';
import 'package:laravel_my_blog_app/models/api_response.dart';
import 'package:laravel_my_blog_app/services/user_service.dart';
import 'package:http/http.dart' as http;

// like or unlike

Future<ApiResponse> likeOrUnlike(int postId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse('$postUrl/$postId/likes'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 404:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}
