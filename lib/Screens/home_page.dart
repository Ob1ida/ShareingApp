import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:obida_app/Screens/login_page.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? imageFile;
  String? imageUrl;
  String? myImage;
  String? myName;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showImageDialog(BuildContext context) {
    String productName = '';
    String productDes = '';
    DateTime productDate =  DateTime.now();
    

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Please Choose an Option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  _getFromCamera();
                },
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.camera,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      "Camera",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  _getFromGallery();
                },
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.image,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      "Gallery",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              TextField(
                onChanged: (value) {
                  productName = value;
                },
                decoration: InputDecoration(
                  labelText: "Photo Name",
                ),
              ),
              TextField(
                onChanged: (value) {
                  productDes = value;
                },
                decoration: InputDecoration(
                  labelText: "Description",
                ),
              ),
            TextField(
  onChanged: (value) {
    setState(() {
      productDate = DateTime.parse(value);
    });
  },
  decoration: InputDecoration(
    labelText: "Date",
  ),
),

    


            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Seçilen fotoğrafın bilgilerini kullanarak işlemler yapabilirsiniz.
                // Örneğin: productName ve productDes değerlerini kullanarak fotoğrafı kaydedebilirsiniz.
                // _savePhoto(productName, productDes);

                Navigator.of(context).pop();
              },
              child: Text('Save'),
                 style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.black
              
            ),)
          ],
        );
      },
    );
  }

  void _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context as BuildContext);
  }

  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context as BuildContext);
  }

  void _cropImage(filepath) async {
    try {
      CroppedFile? croppedImage = await ImageCropper()
          .cropImage(sourcePath: filepath, maxHeight: 1080, maxWidth: 1080);

      if (croppedImage != null) {
        setState(() {
          imageFile = File(croppedImage.path!);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _uploadImage() async {
    if (imageFile == null) {
      Fluttertoast.showToast(msg: "Please Select an Image");
      return;
    }

    // Perform the image upload here
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        floatingActionButton: Wrap(
          direction: Axis.horizontal,
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              child: FloatingActionButton(
                heroTag: "1",
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
                onPressed: () {
                  _showImageDialog(context);
                },
                child: Icon(Icons.camera_enhance),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: FloatingActionButton(
                heroTag: "2",
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
                onPressed: _uploadImage,
                child: const Icon(Icons.cloud_upload),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 0, 0),
                  const Color.fromARGB(255, 255, 255, 255),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.9],
              ),
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginPage()));
            },
            child: const Icon(Icons.login_outlined),
          ),
        ),
      ),
    );
  }
}
