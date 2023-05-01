import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../components/new_post_form.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  bool imageSelected = false;
  late File image;
  final picker = ImagePicker();

  void chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    image = File(pickedFile!.path);
    setState(() {
      imageSelected = true;
    });
  }

  void takeImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    image = File(pickedFile!.path);
    setState(() {
      imageSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!imageSelected) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Wasteagram'),
            centerTitle: true,
          ),
          body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Semantics(
                  button: true,
                  enabled: true,
                  onTapHint: 'choose photo from library',
                  child: ElevatedButton(
                    child: const Text('choose photo'),
                    onPressed: () {
                      chooseImage();
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Semantics(
                  button: true,
                  enabled: true,
                  onTapHint: 'take a new photo',
                  child: ElevatedButton(
                    child: const Text('take photo'),
                    onPressed: () {
                      takeImage();
                    },
                  ),
                ),
              )
            ]),
          ));
    } else {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('Wasteagram'),
            centerTitle: true,
          ),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Semantics(
                  label: 'an image of the wasted items',
                  child: Image.file(image)),
              NewPostForm(image: image)
            ],
          )));
    }
  }
}
