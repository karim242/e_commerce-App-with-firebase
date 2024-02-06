import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_with_firebase/helper/app_methods.dart';
import 'package:e_commerce_app_with_firebase/root_screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import '../custom_button.dart';

class GoogleButtonWidget extends StatelessWidget {
  const GoogleButtonWidget({super.key});

  Future<void> _googleSignIn({required BuildContext context}) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResults = await FirebaseAuth.instance
              .signInWithCredential(GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ));
          if (authResults.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance.collection("user").doc( authResults.user!.uid).set({
              'userId': authResults.user!.uid,
              'userName':  authResults.user!.displayName,
              'userImage':  authResults.user!.photoURL,
              'userEmail':  authResults.user!.email,
              'createdAt': Timestamp.now(),
              'userWish': [],
              'userCart': [],
            });
          }
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.pushReplacementNamed(context, RootScreens.id);
          });
        } on FirebaseException catch (e) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await MyAppMethod.showErrorORWariningDailog(
                context: context,
                subtitle: "An  error occured while registering ${e.message}",
                fct: () {});
          });
        } catch (e) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await MyAppMethod.showErrorORWariningDailog(
                context: context,
                subtitle: "An  error occured while registering to the server$e",
                fct: () {});
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: "sign in with google",
      icon: Ionicons.logo_google,
      color: Colors.red,
      backgroundColor: Colors.white,
      function: () async {
        await _googleSignIn(context: context);
      },
    );
  }
}
