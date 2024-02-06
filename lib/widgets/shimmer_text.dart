import 'package:e_commerce_app_with_firebase/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTitleText extends StatelessWidget {
  const ShimmerTitleText({super.key, required this.label, this.fontSize = 22});
  final String label;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 8),
      baseColor: Colors.purple,
      highlightColor: Colors.redAccent,
      child: TitlesTextWidget(
        label: label,
        fontSize: fontSize,
      ),
    );
  }
}
