import 'dart:io';
import 'package:flutter/material.dart';
import 'package:laravel_my_blog_app/consts/global_variables.dart';
import 'package:laravel_my_blog_app/consts/palette.dart';
import 'package:laravel_my_blog_app/models/api_response.dart';
import 'package:laravel_my_blog_app/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laravel_my_blog_app/screens/login_screen.dart';
import 'package:laravel_my_blog_app/services/user_service.dart';
import 'package:laravel_my_blog_app/utils/add_space.dart';
import 'package:laravel_my_blog_app/utils/navigate_to.dart';
import 'package:laravel_my_blog_app/utils/show_error_message.dart';
import 'package:laravel_my_blog_app/widgets/circle_icon_button.dart';
import 'package:laravel_my_blog_app/widgets/custom_text.dart';
import 'package:laravel_my_blog_app/widgets/custom_text_form_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserModel? user;
  bool _isLoading = false;
  File? _imageFile;
  final _picker = ImagePicker();

  // get image
  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // get user detail
  Future<void> getUser() async {
    ApiResponse response = await getUserDetail();

    if (response.error == null) {
      setState(() {
        user = response.data as UserModel;
        nameController.text = user!.name ?? '';
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            pushLoginScreen(),
          });
    } else {
      showError('${response.error}');
    }
  }

  // update profile
  Future<void> updateProfile() async {
    setState(() {
      _isLoading = true;
    });
    ApiResponse response = await updateUser(
      nameController.text,
      getStringImage(_imageFile),
    );

    if (response.error == null) {
      showError('${response.data}');
    } else if (response.error == unauthorized) {
      pushLoginScreen();
    } else {
      showError('${response.error}');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void pushLoginScreen() {
    pushReplacementTo(
      context,
      const LoginScreen(),
    );
  }

  void showError(String text) {
    showErrorMessage(context, text);
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40)
                .copyWith(bottom: 0),
            child: ListView(
              children: [
                // pp
                Center(
                  child: GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        image: _imageFile == null
                            ? user?.image != null
                                ? DecorationImage(
                                    image: NetworkImage('${user!.image}'),
                                    fit: BoxFit.cover,
                                  )
                                : null
                            : DecorationImage(
                                image: FileImage(_imageFile ?? File('')),
                                fit: BoxFit.cover,
                              ),
                        color: darkPurple,
                      ),
                    ),
                  ),
                ),
                AddSpace().addVerticalSpace(20),
                // name textfield
                Form(
                  key: formKey,
                  child: CustomTextFormField(
                    controller: nameController,
                    validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                    labelText: 'Name',
                    keyboardType: TextInputType.text,
                  ),
                ),
                AddSpace().addVerticalSpace(20),
                // update button
                CircleIconButton(
                  isCircle: false,
                  color: skyBlue,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      updateProfile();
                      debugPrint('update clicked');
                    }
                  },
                  child: Center(
                    child: CustomText(
                      text: 'Update',
                      color: white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // logout button
                CircleIconButton(
                  isCircle: true,
                  color: black,
                  child: Icon(
                    Icons.logout,
                    color: white,
                  ),
                  onTap: () {
                    logout().then(
                      (value) => pushReplacementTo(
                        context,
                        const LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
  }
}
