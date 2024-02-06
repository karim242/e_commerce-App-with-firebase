import 'package:e_commerce_app_with_firebase/root_screens.dart';
import 'package:e_commerce_app_with_firebase/screens/auth/forgot_password.dart';
import 'package:e_commerce_app_with_firebase/screens/auth/register_screen.dart';
import 'package:e_commerce_app_with_firebase/widgets/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';

import '../../const/my_validators.dart';
import '../../widgets/auth/google_btm.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../widgets/shimmer_text.dart';
import '../../widgets/title_text.dart';
import '../../helper/app_methods.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'loginScreen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  bool obscureText = true;
  bool _isLoading = false;
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loginFct() async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      try {
        setState(() => _isLoading = true);
        await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Fluttertoast.showToast(
          msg: "login  successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RootScreens.id);
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        if (e.code == 'user-not-found') {
          await MyAppMethod.showErrorORWariningDailog(
              context: context, subtitle: " ${e.message}", fct: () {});
          if (!mounted) return;
        } else if (e.code == 'wrong-password') {
          await MyAppMethod.showErrorORWariningDailog(
              context: context, subtitle: " ${e.message}", fct: () {});
        }
      } catch (e) {
        if (!mounted) return;
        await MyAppMethod.showErrorORWariningDailog(
            context: context,
            subtitle: "An  error occured while registering to the server$e",
            fct: () {});
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(children: [
              const Gap(60),
              const ShimmerTitleText(
                label: "ShopSmart",
                fontSize: 50,
              ),
              const Gap(10),
              const Align(
                alignment: Alignment.centerLeft,
                child: TitlesTextWidget(label: "Welcome back"),
              ),
              const Gap(10),
              const Align(
                alignment: Alignment.centerLeft,
                child: SubtitleTextWidget(
                    label:
                        "let's get you logged in so you can  start exploring"),
              ),
              const Gap(30),
              Form(
                key: formKey,
                child: Column(
                  children: [
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
                        FocusScope.of(context).requestFocus(passwordFocusNode);
                      },
                    ),
                    const Gap(20),
                    CustomTextFormField(
                      obscureText: obscureText,
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      hintText: "*********",
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
                          obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                      validator: (value) {
                        return MyValidators.passwordValidator(value);
                      },
                      onFieldSubmitted: (value) {
                        _loginFct();
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, ForgotPasswordScreen.routeName);
                        },
                        child: const SubtitleTextWidget(
                          label: "Forgot password?",
                          textDecoration: TextDecoration.underline,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const Gap(40),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        function: () async {
                          _loginFct();
                        },
                        label: 'Login ',
                        color: kDefaultIconDarkColor,
                        icon: Icons.login,
                        backgroundColor: kDefaultIconLightColor,
                      ),
                    ),
                    const Gap(16),
                    SubtitleTextWidget(
                      label: "OR connect using".toUpperCase(),
                    ),
                    const Gap(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const GoogleButtonWidget(),
                        const Gap(26),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(12),
                              // backgroundColor:
                              // Theme.of(context).colorScheme.background,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                            ),
                            child: const Text(
                              "Guest?",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, RootScreens.id);
                            }),
                      ],
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SubtitleTextWidget(
                          label: "Don't have an account?",
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RegisterScreen.id);
                          },
                          child: const SubtitleTextWidget(
                            label: "Sign up",
                            textDecoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
