import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:obida_app/Screens/login_page.dart';
import 'package:obida_app/models/Users.dart';

class ProfileScreen extends StatefulWidget {
  final Users user;
  const ProfileScreen(this.user, {super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState(user);
}

class Address {
  String? street;
  String? city;
  String? state;
  int? postalCode;
  String? country;

  Address({this.street, this.city, this.state, this.postalCode, this.country});
}

class _ProfileScreenState extends State<ProfileScreen> {
  Users users;
  String? name = '';
  String? email = '';
  String? image = '';
  String? phoneNo = '';
  String? surname = '';
  Address userAddress = Address();
  File? imageXFile;

  _ProfileScreenState(this.users);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Adres bilgilerini kaydetme işlemlerini yapabilirsiniz
      print(
          'Added Address: ${userAddress.street}, ${userAddress.city}, ${userAddress.state}, ${userAddress.postalCode}, ${userAddress.country}');
    }
  }

  Future<void> _getDataFromDatabase() async {

    
  }

  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        centerTitle: true,
        backgroundColor: Colors.pink,
        title: const Center(
          child: Text('Profile Screen'),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
          },
        ),
      ),
      body: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                //showimagedialog
              },
              child: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
                minRadius: 60.0,
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: imageXFile == null
                      ? NetworkImage(image!)
                      : Image.file(imageXFile!).image,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Name: ${users.name}',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    //displayTextInputDialog
                  },
                  icon: const Icon(Icons.edit),
                )
              ],
            ),
            const SizedBox(
              height: 11.0,
            ),
            Text(
              'Email: ${users.userEmail}',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(
              height: 11.0,
            ),
            Text(
              'Phone Number: $phoneNo',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(
              height: 11.0,
            ),
            const Text(
              'Address:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 8.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: users.adress.street),
                    onSaved: (value) => users.adress.street = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: users.adress.city),
                    onSaved: (value) => users.adress.city = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: users.adress.state),
                    
                    onSaved: (value) => users.adress.state = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: users.adress.postalCode.toString()),
                    onSaved: (value) =>
                        users.adress.postalCode = int.tryParse(value ?? '')!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: users.adress.country),
                    onSaved: (value) => users.adress.country = value!,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveAddress,
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
              child: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
