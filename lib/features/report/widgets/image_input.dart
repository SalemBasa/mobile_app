import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({Key? key, required this.onPickImage}) : super(key: key);

  final void Function(File image, String base64Image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return;
    }

    final selectedImageFile = File(pickedImage.path);

    // Convert the selected image to a base64 string
    final List<int> imageBytes = await selectedImageFile.readAsBytes();
    final String base64Image = base64Encode(imageBytes);

    setState(() {
      _selectedImage = selectedImageFile;
    });

    widget.onPickImage(_selectedImage!, base64Image); // Pass the base64 string
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: const Color(0xFF49464E),
            ),
          ),
          child: _selectedImage == null
              ? Icon(
                  Icons.camera,
                  size: 100,
                )
              : Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                ),
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.camera),
          label: Text('Take Picture'),
          onPressed: _pickImage,
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFF49464E)),
          ),
        ),
      ],
    );
  }
}
