import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:obida_app/Screens/login_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:obida_app/Screens/profile_screen.dart';
import 'package:obida_app/Screens/search_post.dart';

import '../models/Users.dart';

class HomePage extends StatefulWidget {
  final Users user;
  const HomePage({required this.user});
  @override
  State<HomePage> createState() => _HomePageState(user);
}

class _HomePageState extends State<HomePage> {
  File? imageFile;
  String? imageUrl;
  String? myImage;
  String? myName;
  String _imageString = "";
  String productName = '';
  String productDes = '';
  bool _addPost = false;
  String productDate =  DateTime.now().toString();

  Users users;
  


  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  _HomePageState(this.users);

  

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
      productDate = DateTime.now().toString();
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
              onPressed: () async {

                


                if(_imageString !="" && productName != "" && productDes != "" && productDate.toString() != "")
                {
                  users.AddProduct(productName, productDes, productDate.toString(), _imageString);
                  setState(() {
                    _addPost = true;
                  });
                }
                else{
                  print('please fill the blank feild');
                }

                

                

  
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
    /* XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context as BuildContext); */

    


    final ImagePicker _imagePicker = ImagePicker();
    PickedFile? _pickedImage;

  final pickedImage = await _imagePicker.getImage(source: ImageSource.gallery);
  if(pickedImage != null){
    
    final imageBytes = await pickedImage.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    _pickedImage = pickedImage;
     _imageString = base64Image;  
      
  }
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

  Widget imageFromBase64String(String base64String) {
  Uint8List bytes = base64Decode(base64String);
  return Image.memory(bytes);
}

  Widget AddPost(BuildContext context){

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
        ],

      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        body: _addPost ? AddPost(context) : const SizedBox(),
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 0, 0),
                  Color.fromARGB(255, 255, 255, 255),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.2, 0.9],
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
          
          actions: <Widget>[
            IconButton(
             onPressed:(){
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SearchPost()));
             },
             icon: const Icon(Icons.person_search),
             color: Colors.black, iconSize: 30),

             IconButton(
             onPressed:(){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
             },
             icon: const Icon(Icons.person),
             color: Colors.black, iconSize: 30)
          ],
        ),
      ),
    );
  }
}
