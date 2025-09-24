import 'dart:io';
import 'package:emolog/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;

class ImagePickerTemplate extends StatefulWidget {
  final double maxHeight;
  final double maxWidth;

  const ImagePickerTemplate({
    super.key,
    required this.maxHeight,
    required this.maxWidth,
  });
  @override
  State<ImagePickerTemplate> createState() => _ImagePickerTemplateState();
}

class _ImagePickerTemplateState extends State<ImagePickerTemplate>
    with ImagePickerLogic<ImagePickerTemplate> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // TODO: Cho phép hiển thị minimal kiểu vùng chọn một ảnh (vùng này scrollable), khi muốn chỉnh sửa thì nhấn vào vùng chọn ảnh để hiện các nút chỉnh sửa.
        // TODO: Lưu ảnh thumbnail khi xác nhận (crop lại, có thể cho phép resize bằng tùy chọn trong vùng chọn ảnh)
        children: [
          ImagePreviewArea(
            imageBytes: _displayImageBytes,
            maxHeight: widget.maxHeight,
            maxWidth: widget.maxWidth,
          ),
          SizedBox(height: kPaddingLarge),
          ImageActionButtons(
            onPickImage: pickImage,
            onRotateLeft: () => rotateToggle(false),
            onRotateRight: () => rotateToggle(true),
            onConfirm: () => print("Confirmed"),
          ),
        ],
      ),
    );
  }
}

class ImagePreviewArea extends StatelessWidget {
  final Uint8List? imageBytes;
  final double maxHeight;
  final double maxWidth;

  const ImagePreviewArea({
    super.key,
    this.imageBytes,
    required this.maxHeight,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      height: maxHeight,
      width: maxWidth,
      child: imageBytes == null
          ? Center(
              child: Text(
                "Chưa chọn ảnh",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Image.memory(imageBytes!, fit: BoxFit.cover),
            ),
    );
  }
}

class ImageActionButtons extends StatelessWidget {
  final VoidCallback onPickImage;
  final VoidCallback onRotateLeft;
  final VoidCallback onRotateRight;
  final VoidCallback onConfirm;

  const ImageActionButtons({
    super.key,
    required this.onPickImage,
    required this.onRotateLeft,
    required this.onRotateRight,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: onPickImage, child: Text("Chọn ảnh")),
        SizedBox(width: kPadding),
        ElevatedButton(onPressed: onRotateLeft, child: Icon(Icons.rotate_left)),
        SizedBox(width: kPadding),
        ElevatedButton(
          onPressed: onRotateRight,
          child: Icon(Icons.rotate_right),
        ),
        SizedBox(width: kPadding),
        ElevatedButton(onPressed: onConfirm, child: Text("Xác nhận")),
      ],
    );
  }
}

mixin ImagePickerLogic<T extends StatefulWidget> on State<T> {
  img.Image? _originalImage;
  Uint8List? _displayImageBytes;
  int _rotation = 0;

  Future<void> pickImage() async {
    final imageBytes = await ImageService.pickImage();

    if (imageBytes != null) {
      final decodedImage = img.decodeImage(imageBytes);
      setState(() {
        _originalImage = decodedImage;
        _rotation = 0;
      });
      updateDisplayImage();
    }
  }

  void updateDisplayImage() {
    if (_originalImage == null) return;
    img.Image preview = img.copyRotate(_originalImage!, angle: _rotation);
    final w = preview.width;
    final h = preview.height;
    final maxDim = 1080;
    if (w > maxDim || h > maxDim) {
      final scale = (w > h) ? maxDim / w : maxDim / h;
      preview = img.copyResize(
        preview,
        width: (w * scale).round(),
        height: (h * scale).round(),
      );
    }
    setState(() {
      _displayImageBytes = Uint8List.fromList(
        img.encodeJpg(preview, quality: 100),
      );
    });
  }

  void rotateToggle(bool isRight) {
    setState(() {
      _rotation = (_rotation + (isRight ? 90 : -90)) % 360;
    });
    updateDisplayImage();
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
