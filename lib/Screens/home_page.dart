import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:obida_app/Screens/login_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:obida_app/Screens/profile_screen.dart';
import 'package:obida_app/Screens/search_post.dart';

import '../models/Users.dart';

class HomePage extends StatefulWidget {
  final Users user;
  final List<String> collections;

  const HomePage({required this.user, required this.collections});

  @override
  State<HomePage> createState() => _HomePageState(user, collections);
}

class _HomePageState extends State<HomePage> {
  String changeTitle = "Grid View";
  bool checkView = false;

  File? imageFile;
  String? imageUrl;
  String? myImage;
  String? myName;
  String _imageString = "";
  String productName = '';
  String productDes = '';
  bool _addPost = false;
  DateTime productDate = DateTime.now();
  List<String> collections;
  late String lat;
  late String long;

  Users users;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _HomePageState(this.users, this.collections);

  

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Share Your Product"),
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
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
              TextField(
                onChanged: (value) {
                  productDes = value;
                },
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    productDate = DateTime.now().toString() as DateTime;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Date",
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                
                _getCurrentLocation().then((value) {
                  lat = '${value.latitude}';
                  long = '${value.longitude}';

                  print('latitude: $lat, Longitude: $long');
                });

                if (_imageString != "" &&
                    productName != "" &&
                    productDes != "" &&
                    productDate.toString() != "") {
                  users.AddProduct(
                      productName, productDes, productDate.toString(), _imageString);
                  setState(() {
                    _addPost = true;
                  });
                } else {
                  print('please fill the blank field');
                }


                // Örneğin: productName ve productDes değerlerini kullanarak fotoğrafı kaydedebilirsiniz.
                // _savePhoto(productName, productDes);

                Navigator.of(context).pop();
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
            )
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
    final ImagePicker _imagePicker = ImagePicker();
    PickedFile? _pickedImage;

    final pickedImage = await _imagePicker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final imageBytes = await pickedImage.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      _pickedImage = pickedImage;
      _imageString = base64Image;
    }
  }

  void _cropImage(filepath) async {
    try {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: filepath,
        maxHeight: 1080,
        maxWidth: 1080,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 80,
      );

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
    print(collections);

    // Perform the image upload here
  }

  Widget imageFromBase64String(String base64String) {
    Uint8List bytes = base64Decode(base64String);
    return Image.memory(
      bytes,
      width: 500, // Adjust the width as needed
      height: 250, // Adjust the height as needed
      fit: BoxFit.cover,
    );
  }

  
  Future<Widget> AddPost(BuildContext context,int index) async {
    DatabaseReference databaseRef = FirebaseDatabase.instance.ref();


    final snapshot = await databaseRef.child('Products/${collections[index]}').get();

    Map<dynamic, dynamic>? data = snapshot.value as Map?;

     productDes = data?['productDes'];
    productDes = data?['productDes'];
    _imageString = data?['imageUrl'] ?? '';

    print(_imageString);

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19.0,
            ),
          ),
          SizedBox(height: 8.0),
          Text(productDes),
          SizedBox(height: 8.0),
          imageFromBase64String(_imageString),
          SizedBox(height: 8.0),
        CircleAvatar( // Add CircleAvatar to display user's image
          backgroundImage: NetworkImage(myImage ?? ''), // Provide the user's image URL
          radius: 24.0,
        ),
        ],
      ),
    );
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission are permanently denied, we cannot request');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
             Colors.pink,
             Colors.deepOrange,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.2, 0.9],
        ),
      ),
      child: Scaffold(
         
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child:Card(
                elevation: 16.0,
                shadowColor: Colors.white10,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink, Colors.deepOrange.shade300],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.2,0.9],
                    )
                  ),
                  child: FutureBuilder<Widget>(
                  future: AddPost(context, index),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return snapshot.data ?? SizedBox();
                    }
                  },
                ),             
                ),
              ),
              );
          },
        ),
        floatingActionButton: Wrap(
          direction: Axis.horizontal,
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              child: FloatingActionButton(
                heroTag: "1",
                backgroundColor: Colors.deepOrange,
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
                backgroundColor: Colors.pink,
                onPressed: _uploadImage,
                child: const Icon(Icons.cloud_upload),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink,
                  Colors.deepOrange,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.2, 0.9],
              ),
            ),
          ),
          title: GestureDetector(
            onTap: () {
              setState(() {
                changeTitle = "List View";
                checkView = true;
              });
            },
            onDoubleTap: () {
              setState(() {
                changeTitle = "Grid View";
                checkView = false;
              });
            },
            child: Text(changeTitle),
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
            },
            child: const Icon(Icons.login_outlined),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SearchPost()));
              },
              icon: const Icon(Icons.person_search),
              color: Colors.black,
              iconSize: 30,
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen(users)));
              },
              icon: const Icon(Icons.person),
              color: Colors.black,
              iconSize: 30,
            )
          ],
        ),
      ),
    );
  }
}
  
  

