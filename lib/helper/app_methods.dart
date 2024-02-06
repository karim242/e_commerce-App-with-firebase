import 'package:e_commerce_app_with_firebase/helper/assets_manager.dart';
import 'package:e_commerce_app_with_firebase/widgets/subtitle_text.dart';
import 'package:e_commerce_app_with_firebase/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MyAppMethod {
  static Future<void> showErrorORWariningDailog({
    required BuildContext context,
    required String subtitle,
    required Function fct,
    bool isError = true,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Image.asset(
                AssetsManager.warning,
                height: 60,
                width: 60,
              ),
              const Gap(10),
              SubtitleTextWidget(
                label: subtitle,
                fontWeight: FontWeight.w400,
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: !isError,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const SubtitleTextWidget(
                        label: "Cancel",
                        color: Colors.amberAccent,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      fct();
                      Navigator.pop(context);
                    },
                    child: const SubtitleTextWidget(
                      label: "OK",
                      color: Colors.red,
                    ),
                  ),
                ],
              )
            ]),
          );
        });
  }

  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function cameraFct,
    required Function galleryFct,
    required Function removeFct,
  }) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return FittedBox(
            child: AlertDialog(
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: const Center(
                child: TitlesTextWidget(label: "Choose option"),
              ),
              content: ListBody(children: [
                TextButton.icon(
                  onPressed: () {
                    cameraFct();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text("Camera"),
                ),
                TextButton.icon(
                  onPressed: () {
                    galleryFct();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Gallery"),
                ),
                TextButton.icon(
                  onPressed: () {
                    removeFct();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.remove),
                  label: const Text("Remove"),
                ),
              ]),
            ),
          );
        });
  }
}
