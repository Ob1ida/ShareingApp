import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class Users {

 late String name;
  late String surname;
  late String userID;
  late String password;
  late String userEmail;

  Users(); //Named constructor




  // ignore: non_constant_identifier_names

Future<void> CreateUser(String UserID) async {

   DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  
  final snapshot = await databaseRef.child('users/$UserID').get();
  
  
    Map<dynamic, dynamic>? data = snapshot.value as Map?;

     name = data?['name'];
    surname = data?['surname'];
    userID = UserID;
    password = data?['password'];
    userEmail = data?['email'];

    print('$name $surname');

}





}