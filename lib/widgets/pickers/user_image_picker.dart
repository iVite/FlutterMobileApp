import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);

  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  final imagePicker = ImagePicker();



  void _imageFromCamera() async {
    PickedFile pickedFile = await imagePicker.getImage(
        source: ImageSource.camera,
        maxWidth: 150
    );

    setState(() {
      _pickedImage = File(pickedFile.path);
    });
    widget.imagePickFn(_pickedImage);
  }

  void _imageFromGallery() async {
    PickedFile pickedFile = await imagePicker.getImage(
      source: ImageSource.gallery,
      maxWidth: 150
    );

    setState(() {
      _pickedImage = File(pickedFile.path);
    });
    widget.imagePickFn(_pickedImage);
  }

  void _showImagePicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Image Gallery'),
                    onTap: () {
                      _imageFromGallery();
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imageFromCamera();
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _showImagePicker,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
