// Strings

import 'package:flutter/material.dart';
import 'package:laravel_my_blog_app/consts/palette.dart';

const baseURL = "http://192.168.1.39:8000/api";
const loginUrl = '$baseURL/login';
const registerUrl = '$baseURL/register';
const logoutUrl = '$baseURL/logout';
const userUrl = '$baseURL/user';
const postUrl = '$baseURL/posts';
const commentsUrl = '$baseURL/comments';

// errors

const serverError = 'Server Error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong , try again!';

// input decoration

InputDecoration kInputDecoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
    contentPadding: const EdgeInsets.all(10),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: black,
      ),
    ),
  );
}
