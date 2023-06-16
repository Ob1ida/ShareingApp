import 'dart:async';
import 'dart:convert';


import 'package:firebase_database/firebase_database.dart';

import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';



import 'Adress.dart';
import 'products.dart';

class Users {

 late String name;
  late String surname;
  late String userID;
  late String password;
  late String userEmail;

  late List<products> myProducts;

  Adress adress = Adress();

  Users(); //Named constructor




  // ignore: non_constant_identifier_names

Future<void> CreateUser(String UserID) async {

  userID = UserID;

   DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  
  final snapshot = await databaseRef.child('users/$UserID').get();
  
  
    Map<dynamic, dynamic>? data = snapshot.value as Map?;

     name = data?['name'];
    surname = data?['surname'];
    password = data?['password'];
    userEmail = data?['email'];

    print('$name $surname');

}

void createAdress(){

  adress.street = 'yalova';
  adress.city = 'Manisa';
  adress.state = 'Turgutlu';
  adress.postalCode = 161242;
  adress.country = 'Turkiye';

  DatabaseReference ref = FirebaseDatabase.instance.ref().child('users/$userID');
  ref.child('address').set({

    'street': adress.street,
    'city': adress.city,
    'state': adress.state,
    'postalCode': adress.postalCode,
    'country': adress.country,
    
    }).then((value) {

      print('Address saved successfully');
    }).catchError((error){
      print('Failed to save address: $error');
    });




}

Future<void> AddProduct()  async {
  late String _imageString;

  final ImagePicker _imagePicker = ImagePicker();
  PickedFile? _pickedImage;

  final pickedImage = await _imagePicker.getImage(source: ImageSource.gallery);
  if(pickedImage != null){
    
    final imageBytes = await pickedImage.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    _pickedImage = pickedImage;
     _imageString = base64Image;    
  }

  products pr = products();
  pr.productName = "pC";
  pr.productDes = "New Laptop Rtx 4090 64 gb ram";
  pr.productDate = DateTime.now();

  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final uuid = Uuid();

  String uid = uuid.v4();
  String? newItemKey = ref.child('Products').push().key;

  Map<String, dynamic> newProduct = {
    'ProductName':pr.productName,
    'productDes':pr.productDes,
    'productDate':pr.productDate.toString(),
    'image': _imageString,
  };

  ref.child('Products/$uid').set(newProduct).then((value) {
    print('Product added successfully.');

  }).catchError((error){
    print('Failed to add item:$error');

  });






}

  

  
  



}

