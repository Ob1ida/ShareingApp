import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:obida_app/Screens/home_page.dart';
import 'package:obida_app/Screens/login_page.dart';
import 'package:obida_app/models/Users.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
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
  String? name = '';
  String? email = '';
  String? image = '';
  String? phoneNo = '';
  String? surname = '';
  Address userAddress = Address();
  File? imageXFile;

  Future<void> _getDataFromDatabase() async {
    final DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(FirebaseAuth.instance.currentUser!.uid);

    ref.onValue.listen(
      (event) {
        final snapshot = event.snapshot;
        if (snapshot.value != null) {
          setState(() {
            final data = snapshot.value as Map<dynamic, dynamic>;
            name = data["name"] as String?;
            email = data["email"] as String?;
            image = data["image"] as String?;
            phoneNo = data["phoneNo"] as String?;
          });
        }
      },
    );
    onError:
    (error) {
      // Hata durumunda yapılacak işlemler
      print('Hata: $error');
    };
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      DatabaseReference addressRef =
      FirebaseDatabase.instance.reference().child('addresses');
      DatabaseReference newAddressRef = addressRef.push();
      newAddressRef.set({
        'street': userAddress.street,
        'city': userAddress.city,
        'state': userAddress.state,
        'postalCode': userAddress.postalCode,
        'country': userAddress.country,
      }).then((_) {
        print('Address saved successfully!');
      }).catchError((error) {
        print('Failed to save address: $error');
      });
    }
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
                  radius: 55.0,
                  backgroundImage: imageXFile == null
                      ? 
                      NetworkImage(
                        image!
                        )
                      : 
                      Image.file
                      (imageXFile!).image,
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
                  'Name: ' + name!,
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
              'Email: ' + email!,
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
              'Phone Number: ' + phoneNo!,
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
                    decoration: InputDecoration(labelText: 'Street'),
                    onSaved: (value) => userAddress.street = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'City'),
                    onSaved: (value) => userAddress.city = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'State'),
                    onSaved: (value) => userAddress.state = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Postal Code'),
                    onSaved: (value) =>
                        userAddress.postalCode = int.tryParse(value ?? ''),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Country'),
                    onSaved: (value) => userAddress.country = value,
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
