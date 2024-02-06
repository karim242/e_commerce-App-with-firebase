import 'package:flutter/material.dart';


// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    required this.controller,
     this.focusNode,
    required this.prefixIcon,
    required this.hintText,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
   FocusNode? focusNode;
  Widget? suffixIcon;
  final Widget prefixIcon;

  final String hintText;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  bool? obscureText;
  
 String? Function(String?)? validator;
  Function(String)? onFieldSubmitted;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText!,
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
