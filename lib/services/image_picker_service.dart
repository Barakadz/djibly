import 'dart:convert';
import 'dart:io';

import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

class ImagePickerService {
  static Future<String> getBase64Image(File image) async {
    try {
      String base64Image = base64Encode(await image.readAsBytes());
      return 'data:image/jpeg;base64,' + base64Image;
    } catch (e) {
      return null;
    }
  }

  static Future<PickedFile> getImageFromGallery() async {
    final _picker = ImagePicker();
    PickedFile file =
        await _picker.getImage(source: ImageSource.gallery).then((pickedImage) {
      return pickedImage;
    }).catchError((e) {
      ToastService.showErrorToast(
        MyApp.navigatorKey.currentContext.translate.something_went_wrong_body,
      );
      return null;
    });
    return file;
  }

  static Future<File> cropImage(image) async {
    final cropper = ImageCropper();
    final croppedFile = await cropper.cropImage(
      sourcePath: image,
      cropStyle: CropStyle.rectangle,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      maxHeight: 300,
      maxWidth: 300,
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: '',
          showCropGrid: false,
          toolbarColor: Colors.grey,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          hideBottomControls: true,
          lockAspectRatio: true),
      iosUiSettings: IOSUiSettings(
        title: '',
      ),
    );
    return File(croppedFile.path);
  }
}
