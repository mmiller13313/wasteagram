import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/post.dart';

class NewPostForm extends StatefulWidget {
  const NewPostForm({super.key, required this.image});

  final File image;

  @override
  State<NewPostForm> createState() => _NewPostFormState();
}

class _NewPostFormState extends State<NewPostForm> {
  final _formKey = GlobalKey<FormState>();
  final postFields = Post();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration:
                  const InputDecoration(hintText: 'Number of wasted items'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3)
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter the number of wasted items';
                }
                return null;
              },
              onSaved: (value) {
                postFields.quantity = int.parse(value!);
              },
            ),
          ),
          Semantics(
            button: true,
            enabled: true,
            onTapHint: 'upload post to database',
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(80),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero)),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    addDate();
                    // move addURL up, so not waiting here?
                    await addURL(widget.image);
                    await addLocation();
                    uploadPost();
                    Navigator.of(context).pop();
                  }
                },
                child: const Icon(
                  Icons.cloud_upload,
                  size: 60.0,
                )),
          ),
        ],
      ),
    );
  }

  void addDate() {
    DateTime now = DateTime.now();
    postFields.dateTime = now;
  }

  Future<void> addURL(image) async {
    var fileName = '${DateTime.now()}.jpg';
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageReference.putFile(image!);
    await uploadTask;
    postFields.imageURL = await storageReference.getDownloadURL();
  }

  Future<void> addLocation() async {
    Location locationService = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData locationData;

    _serviceEnabled = await locationService.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await locationService.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await locationService.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await locationService.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await locationService.getLocation();
    postFields.latitude = locationData.latitude!;
    postFields.longitude = locationData.longitude!;
  }

  // make async?
  void uploadPost() {
    FirebaseFirestore.instance
        .collection('posts')
        .add(postFields.toFirestore());
  }
}
