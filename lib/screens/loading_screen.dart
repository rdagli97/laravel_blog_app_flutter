import 'package:flutter/material.dart';
import 'package:laravel_my_blog_app/consts/global_variables.dart';
import 'package:laravel_my_blog_app/models/api_response.dart';
import 'package:laravel_my_blog_app/screens/home_screen.dart';
import 'package:laravel_my_blog_app/screens/login_screen.dart';
import 'package:laravel_my_blog_app/services/user_service.dart';
import 'package:laravel_my_blog_app/utils/navigate_to.dart';
import 'package:laravel_my_blog_app/utils/show_error_message.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<void> _loadUserInfo() async {
    String token = await getToken();
    if (token == '') {
      goToLoginScreen();
    } else {
      ApiResponse response = await getUserDetail();
      if (response.error == null) {
        goToHomeScreen();
      } else if (response.error == unauthorized) {
        goToLoginScreen();
      } else {
        Builder(
          builder: (context) {
            showErrorMessage(context, '${response.error}');
            return const SizedBox.shrink();
          },
        );
      }
    }
  }

  void goToLoginScreen() {
    pushReplacementTo(
      context,
      const LoginScreen(),
    );
  }

  void goToHomeScreen() {
    pushReplacementTo(
      context,
      const HomeScreen(),
    );
  }

  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
