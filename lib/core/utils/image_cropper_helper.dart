import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../theme/app_color.dart';

class ImageCropperHelper {
  static final ImagePicker _picker = ImagePicker();

  /// Pick an image from gallery or camera, crop it to 1:1, and compress it.
  static Future<File?> pickCropAndCompressImage({
    required BuildContext context,
    required ImageSource source,
  }) async {
    try {
      // 1. Pick Image
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return null;

      // 2. Crop Image
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Photo',
            toolbarColor: AppColor.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Photo',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile == null) return null;

      // 3. Compress Image
      final targetPath = '${croppedFile.path}_compressed.jpg';
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        croppedFile.path,
        targetPath,
        quality: 70, // 70% quality for profile photo
        minWidth: 512,
        minHeight: 512,
      );

      if (compressedFile == null) return null;
      return File(compressedFile.path);
    } catch (e) {
      return null;
    }
  }
}
