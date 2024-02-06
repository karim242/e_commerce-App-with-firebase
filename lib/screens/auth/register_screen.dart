import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_with_firebase/root_screens.dart';
import 'package:e_commerce_app_with_firebase/widgets/auth/image_picker_widget.dart';
import 'package:e_commerce_app_with_firebase/widgets/shimmer_text.dart';
import 'package:e_commerce_app_with_firebase/widgets/subtitle_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../const/my_validators.dart';
import '../../helper/app_methods.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_form_field.dart';

import '../../widgets/title_text.dart';
import '../loading_manager.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static String id = 'RegisterScreen';
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController confiremPasswordController;
  late TextEditingController passwordController;
  late FocusNode emailFocusNode;
  late FocusNode nameFocusNode;
  late FocusNode confiremPasswordFocusNode;
  late FocusNode passwordFocusNode;
  bool _isLoading = false;
  XFile? pickedImage;
  bool obscureText = true;
  String? userImageUrl;
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    emailController = TextEditingController();
    nameController = TextEditingController();
    confiremPasswordController = TextEditingController();
    passwordController = TextEditingController();
    emailFocusNode = FocusNode();
    nameFocusNode = FocusNode();
    confiremPasswordFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    confiremPasswordController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    nameFocusNode.dispose();
    confiremPasswordFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _registerFct() async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (pickedImage == null) {
      MyAppMethod.showErrorORWariningDailog(
        context: context,
        subtitle: "Make sure to pick up an image",
        fct: () {},
      );
      return;
    }
    if (isValid) {
      formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });
        final ref = FirebaseStorage.instance
            .ref()
            .child("usersImages")
            .child('${emailController.text.trim()}.jpg');
        await ref.putFile(File(pickedImage!.path));
        userImageUrl = await ref.getDownloadURL();

        await auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        User? user = auth.currentUser;
        final uid = user!.uid;
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          'userId': uid,
          'userName': nameController.text,
          'userImage': userImageUrl,
          'userEmail': emailController.text.toLowerCase(),
          'createdAt': Timestamp.now(),
          'userWish': [],
          'userCart': [],
        });
        Fluttertoast.showToast(
          msg: "An account has been created",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
        );
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RootScreens.id);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          if (!mounted) return;
          await MyAppMethod.showErrorORWariningDailog(
              context: context,
              subtitle: "An  error occured while registering ${e.message}",
              fct: () {});
        } else if (e.code == 'email-already-in-use') {
          if (!mounted) return;
          await MyAppMethod.showErrorORWariningDailog(
              context: context,
              subtitle: "An  error occured while registering ${e.message}",
              fct: () {});
        }
      } catch (e) {
        await MyAppMethod.showErrorORWariningDailog(
            context: context,
            subtitle: "An  error occured while registering to the server$e",
            fct: () {});
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await MyAppMethod.imagePickerDialog(
      context: context,
      cameraFct: () async {
        pickedImage = await picker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFct: () async {
        pickedImage = await picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFct: () {
        setState(() {
          pickedImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: LoadingManager(
          isLoading: _isLoading,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(children: [
                const Gap(30),
                const ShimmerTitleText(
                  label: "ShopSmart",
                  fontSize: 40,
                ),
                const Gap(10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitlesTextWidget(label: "Welcome"),
                      SubtitleTextWidget(label: "Your welcome message")
                    ],
                  ),
                ),
                const Gap(15),
                SizedBox(
                  height: size.width * 0.3,
                  width: size.width * 0.3,
                  child: ImagePickerWidget(
                    pickedImage: pickedImage,
                    function: () async {
                      await localImagePicker();
                    },
                  ),
                ),
                const Gap(30),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: nameController,
                        focusNode: nameFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        prefixIcon: const Icon(
                          IconlyLight.profile,
                        ),
                        hintText: "name",
                        validator: (value) {
                          return MyValidators.displayNamevalidator(value);
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(emailFocusNode);
                        },
                      ),
                      const Gap(16),
                      CustomTextFormField(
                        controller: emailController,
                        focusNode: emailFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(
                          IconlyLight.message,
                        ),
                        hintText: "Email address",
                        validator: (value) {
                          return MyValidators.emailValidator(value);
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(passwordFocusNode);
                        },
                      ),
                      const Gap(20),
                      CustomTextFormField(
                        obscureText: obscureText,
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        hintText: "password",
                        prefixIcon: const Icon(
                          IconlyLight.lock,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          icon: Icon(
                            obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        validator: (value) {
                          return MyValidators.passwordValidator(value);
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(confiremPasswordFocusNode);
                        },
                      ),
                      const Gap(20),
                      CustomTextFormField(
                        obscureText: obscureText,
                        controller: confiremPasswordController,
                        focusNode: confiremPasswordFocusNode,
                        hintText: "confirm password",
                        prefixIcon: const Icon(
                          IconlyLight.lock,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          icon: Icon(
                            obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        validator: (value) {
                          return MyValidators.repeatPasswordValidator(value,
                              password: passwordController.text);
                        },
                        onFieldSubmitted: (value) {
                          _registerFct();
                        },
                      ),
                      const Gap(40),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          function: () async {
                            _registerFct();
                          },
                          label: 'Sign up ',
                          color: kDefaultIconDarkColor,
                          icon: IconlyLight.add_user,
                          backgroundColor: kDefaultIconLightColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
