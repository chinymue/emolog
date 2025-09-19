import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';

class ImagePickerTemplate extends StatefulWidget {
  @override
  State<ImagePickerTemplate> createState() => _ImagePickerTemplateState();
}

class _ImagePickerTemplateState extends State<ImagePickerTemplate> {
  Uint8List? _imageBytes;

  Future<void> _pickImage() async {
    final imageBytes = await ImageService.pickImage();

    if (imageBytes != null) {
      setState(() {
        _imageBytes = imageBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Picker Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageBytes == null
                ? Text("Chưa chọn ảnh")
                : Image.memory(_imageBytes!, height: 200),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _pickImage, child: Text("Chọn ảnh")),
          ],
        ),
      ),
    );
  }
}

class ImageService {
  static Future<Uint8List?> pickImage({bool fromCamera = false}) async {
    try {
      // Nếu là mobile hoặc web → dùng image_picker
      if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
        final ImagePicker picker = ImagePicker();
        final XFile? file = await picker.pickImage(
          source: fromCamera ? ImageSource.camera : ImageSource.gallery,
          maxWidth: 800,
          imageQuality: 85,
        );
        if (file == null) return null;
        return await file.readAsBytes(); // trả về Uint8List
      }

      // Nếu là desktop (Windows, macOS, Linux) → dùng file_picker
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );
        if (result == null) return null;
        return await File(result.files.single.path!).readAsBytes();
      }

      return null;
    } catch (e) {
      debugPrint("Image pick error: $e");
      return null;
    }
  }
}
