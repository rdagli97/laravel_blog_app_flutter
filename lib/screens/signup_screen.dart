import 'package:flutter/material.dart';
import 'package:laravel_my_blog_app/consts/palette.dart';
import 'package:laravel_my_blog_app/models/api_response.dart';
import 'package:laravel_my_blog_app/models/user_model.dart';
import 'package:laravel_my_blog_app/screens/home_screen.dart';
import 'package:laravel_my_blog_app/screens/login_screen.dart';
import 'package:laravel_my_blog_app/services/user_service.dart';
import 'package:laravel_my_blog_app/utils/add_space.dart';
import 'package:laravel_my_blog_app/utils/navigate_to.dart';
import 'package:laravel_my_blog_app/utils/show_error_message.dart';
import 'package:laravel_my_blog_app/widgets/custom_flat_button.dart';
import 'package:laravel_my_blog_app/widgets/custom_text.dart';
import 'package:laravel_my_blog_app/widgets/custom_text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();
  bool _isLoading = false;

  // register user
  void _registerUser() async {
    setState(() {
      _isLoading = true;
    });
    ApiResponse response = await register(
        nameController.text, emailController.text, passwordController.text);
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
    pushReplacementTo(context, const HomeScreen());
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cPasswordController.dispose();
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
            // icon
            const Icon(
              Icons.two_wheeler_outlined,
              size: 100,
            ),
            AddSpace().addVerticalSpace(20),
            // name textfield
            CustomTextFormField(
              controller: nameController,
              keyboardType: TextInputType.emailAddress,
              labelText: 'Name',
              validator: (val) => val!.isEmpty ? "Name can't be blank" : null,
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
            // confirm password textfield
            CustomTextFormField(
              isPass: true,
              controller: cPasswordController,
              keyboardType: TextInputType.text,
              labelText: 'Confirm Password',
              validator: (val) => val != passwordController.text
                  ? 'Passwords does not match'
                  : null,
            ),
            AddSpace().addVerticalSpace(20),
            Row(
              children: [
                // Don you have an account ?
                const CustomText(
                  text: "Do you have an account?",
                ),
                // Log in now
                GestureDetector(
                  onTap: () {
                    pushTo(
                      context,
                      const LoginScreen(),
                    );
                  },
                  child: const CustomText(
                    text: ' Log in now',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            AddSpace().addVerticalSpace(20),
            // Signup button
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomFlatButton(
                    color: darkPurple,
                    text: 'Sign up',
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          _registerUser();
                        });
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
