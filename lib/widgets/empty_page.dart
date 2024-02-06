import 'package:e_commerce_app_with_firebase/widgets/custom_button.dart';
import 'package:e_commerce_app_with_firebase/widgets/subtitle_text.dart';
import 'package:e_commerce_app_with_firebase/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';


class EmptyPage extends StatelessWidget {
  const EmptyPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });
  final String image, title, subtitle;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: SingleChildScrollView(
        child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(image,
                height: size.height * 1 / 3, width: double.infinity),
            const TitlesTextWidget(
              label: "Whoops !",
              fontSize: 30,
              color: Colors.red,
            ),
            const Gap(10),
            SubtitleTextWidget(
              label: title,
              fontSize: 22,
            ),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SubtitleTextWidget(label: subtitle),
            ),
            const Gap(10),
            CustomButton(
              label: "Shop Now",
              color: Colors.white,
              icon: IconlyLight.buy,
             
            )
          ],
        ),
      ),
    );
  }
}
