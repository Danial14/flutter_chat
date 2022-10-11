import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget{
  void Function(File? iMage) subMitIMage;
  UserImagePicker({required this.subMitIMage});
  @override
  State<UserImagePicker> createState() {
    return UserImagePickerState();
  }
}
class UserImagePickerState extends State<UserImagePicker>{
  File? _iMageFile;
  void _pickIMage() async{
    final iMage = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    setState(() {
      _iMageFile = File(iMage!.path);
      widget.subMitIMage(_iMageFile!);
    });
  }
  @override
  Widget build(BuildContext context) {
    print("iMage build");
    return Column(
      children: <Widget>[
        CircleAvatar(radius: 60, backgroundImage: _iMageFile == null ? null : FileImage(_iMageFile!), backgroundColor: Colors.amberAccent,),
        TextButton.icon(onPressed: _pickIMage,
          icon: Icon(Icons.image),
          label: Text("Add iMage",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}