import 'package:flutter/material.dart';
import 'package:laravel_my_blog_app/consts/palette.dart';
import 'package:laravel_my_blog_app/models/api_response.dart';
import 'package:laravel_my_blog_app/models/user_model.dart';
import 'package:laravel_my_blog_app/screens/home_screen.dart';
import 'package:laravel_my_blog_app/screens/signup_screen.dart';
import 'package:laravel_my_blog_app/services/user_service.dart';
import 'package:laravel_my_blog_app/utils/add_space.dart';
import 'package:laravel_my_blog_app/utils/navigate_to.dart';
import 'package:laravel_my_blog_app/utils/show_error_message.dart';
import 'package:laravel_my_blog_app/widgets/custom_flat_button.dart';
import 'package:laravel_my_blog_app/widgets/custom_text.dart';
import 'package:laravel_my_blog_app/widgets/custom_text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  // login user
  void _loginUser() async {
    setState(() {
      _isLoading = true;
    });
    ApiResponse response = await login(
      emailController.text,
      passwordController.text,
    );

    if (response.error == null) {
      setState(() {
        _isLoading = false;
      });
      _saveAndGoHome(response.data as UserModel);
    } else {
      setState(() {
        _isLoading = false;
      });
      Builder(
        builder: (context) {
          showErrorMessage(context, '${response.error}');
          return const SizedBox();
        },
      );
    }
  }

  void _saveAndGoHome(UserModel userModel) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', userModel.token ?? '');
    await pref.setInt('userId', userModel.id ?? 0);
    goToHomeScreen();
  }

  void goToHomeScreen() {
    pushReplacementTo(
      context,
      const HomeScreen(),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            AddSpace().addVerticalSpace(100),
            // icon
            const Icon(
              Icons.two_wheeler_outlined,
              size: 100,
            ),
            AddSpace().addVerticalSpace(20),
            // email textfield
            CustomTextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              labelText: 'Email',
              validator: (val) => val!.isEmpty ? 'Invalid email adress' : null,
            ),
            AddSpace().addVerticalSpace(20),
            // password textfield
            CustomTextFormField(
              isPass: true,
              controller: passwordController,
              keyboardType: TextInputType.text,
              labelText: 'Password',
              validator: (val) =>
                  val!.length < 6 ? 'Required at least 6 chars' : null,
            ),
            AddSpace().addVerticalSpace(20),
            Row(
              children: [
                // Don't you have an account ?
                const CustomText(
                  text: "Don't you have an account?",
                ),
                // Sign up now
                GestureDetector(
                  onTap: () {
                    pushTo(
                      context,
                      const SignUpScreen(),
                    );
                  },
                  child: const CustomText(
                    text: ' Sign up now',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            AddSpace().addVerticalSpace(20),
            // Login button
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomFlatButton(
                    color: darkPurple,
                    text: 'Log in',
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        _loginUser();
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
