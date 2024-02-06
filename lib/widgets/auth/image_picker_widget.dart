import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget(
      {super.key, this.pickedImage, required this.function});
  final XFile? pickedImage;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: pickedImage == null
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey
                      ),
                  ),
                )
              : Image.file(
                  File(pickedImage!.path),
                  fit: BoxFit.fill,
                ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Material(
            borderRadius: BorderRadius.circular(12),
            // color: Theme.of(context).secondaryHeaderColor,
            color: const Color(0xFFC66868),
            child: InkWell(
              onTap: () async {
                await function();
              },
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.add_a_photo_outlined,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
