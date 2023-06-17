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

Future<void> AddProduct(String productName,String productDes,String ProductDate,String Image)  async {
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final uuid = Uuid();

  String uid = uuid.v4();
  String? newItemKey = ref.child('Products').push().key;

  Map<String, dynamic> newProduct = {
    'UserID': userID,
    'ProductName':productName,
    'productDes':productDes,
    'productDate':ProductDate.toString(),
    'imageUrl': Image,
    'ProductID':uid,

  };

  ref.child('Products/$uid').set(newProduct).then((value) {
    print('Product added successfully.');

  }).catchError((error){
    print('Failed to add item:$error');

  });

  AddToMyProducts(uid, productName, productDes, ProductDate, Image);

  myProducts.add(newProduct as products);
  

  

 








}

void AddToMyProducts(String uid,String productName,String productDes,String ProductDate,String Image){

DatabaseReference ref = FirebaseDatabase.instance.ref();
 String? newItemKey = ref.child('Products').push().key;

  Map<String, dynamic> newProduct = {
    'UserID': userID,
    'UserName': name,
    'ProductName':productName,
    'productDes':productDes,
    'productDate':ProductDate.toString(),
    'image': Image,
  };

  ref.child('users/$userID/MyProducts/$uid').set(newProduct).then((value) {
    print('Product added successfully to MyProducts .');

  }).catchError((error){
    print('Failed to add item:$error');

  });


}

  

  
  



}

