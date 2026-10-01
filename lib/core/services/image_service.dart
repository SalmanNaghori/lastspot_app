import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<List<File>> pickMultipleImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    return pickedFiles.map((pf) => File(pf.path)).toList();
  }

  Future<File?> pickSingleImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<File?> pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  /// Picks and automatically compresses multiple images
  Future<List<File>> pickAndCompressMultipleImages() async {
    final pickedFiles = await pickMultipleImages();
    final compressedFiles = <File>[];
    for (final f in pickedFiles) {
      final comp = await compressImage(f);
      if (comp != null) compressedFiles.add(comp);
    }
    return compressedFiles;
  }

  /// Picks and automatically compresses a single image from gallery or camera
  Future<File?> pickAndCompressSingleImage({bool fromCamera = false}) async {
    final file = fromCamera
        ? await pickImageFromCamera()
        : await pickSingleImage();
    if (file != null) {
      return await compressImage(file);
    }
    return null;
  }

  /// Compresses an image, preserving aspect ratio.
  /// Uses max long edge ~1920px as per project rules.
  Future<File?> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.absolute.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minWidth: 1920,
      minHeight: 1920,
      quality: 85,
    );

    if (result != null) {
      return File(result.path);
    }
    return null;
  }
}
