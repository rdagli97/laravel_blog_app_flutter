import 'dart:convert';

import 'package:laravel_my_blog_app/consts/global_variables.dart';
import 'package:laravel_my_blog_app/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:laravel_my_blog_app/models/comment_model.dart';
import 'package:laravel_my_blog_app/services/user_service.dart';

// get a comment of a post

Future<ApiResponse> getComments(int postId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$postUrl/$postId/comments'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch (response.statusCode) {
      case 200:
        List<dynamic> commentJson =
            List.from(jsonDecode(response.body)['comments']);
        apiResponse.data =
            commentJson.map((e) => CommentModel.fromJson(e)).toList();
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

// create a comment

Future<ApiResponse> createComment(int postId, String comment) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse('$postUrl/$postId/comments'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'comment': comment,
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
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

// edit a comment

Future<ApiResponse> editComment(int commentId, String comment) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.put(
      Uri.parse('$commentsUrl/$commentId'),
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

// delete a comment

Future<ApiResponse> deleteComment(int commentId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response =
        await http.delete(Uri.parse('$commentsUrl/$commentId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 404:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 403:
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
