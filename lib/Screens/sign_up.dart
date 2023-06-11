import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/square_tile.dart';
import 'login_page.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  late String name, surname, email, password;
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  var SignedUp = false;

  // text editing controllers
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  get dbRef => null;

  // sign user up method
  void signUpUser() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        var userResult = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
          name: name,
          surname: surname,
        );
        print(userResult.user!.uid);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    appBar:
    AppBar(
      leading: IconButton(
        icon: Image.asset(
            'assets/images/back_icon.png'), // back_icon.png'nin yolunu doğru şekilde ayarlayın
        onPressed: () {
          Navigator.of(context)
              .pop(); // Önceki sayfaya geri dönmek için pop() kullanılır
        },
      ),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 254, 254),
      body: SafeArea(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                ImageIcon(
                  AssetImage('assets/images/register.png'),
                  size: 100,
                ),
                const SizedBox(height: 50),

                const SizedBox(height: 25),

                // name textfield
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Your Name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value!;
                  },
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                  ),
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                // surname textfield
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Your Surname';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    surname = value!;
                  },
                  controller: surnameController,
                  decoration: const InputDecoration(
                    hintText: 'Surname',
                  ),
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                // email textfield
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Your Email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value!;
                  },
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                // password textfield
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Your Password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!;
                  },
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // sign up button
Center(
  child: TextButton(
    onPressed: () async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        try {
          var userResult = await firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
            name: name,
            surname: surname,
          );
          print(userResult.user!.uid);
          SignedUp = true;

           if (SignedUp) {
            DatabaseReference? dbRef = FirebaseService().dbRef;
            await dbRef?.child('users').child(userResult.user!.uid).set({
              'name': name,
              'surname': surname,
              'email': email,
              'password': password,
            });
        } } catch (e) {
          print(e.toString());
        }
         
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      },
    
    child: const Text(
      "Create Account",
      selectionColor: Color.fromARGB(255, 105, 58, 247),
    ),
  ),
),

                const SizedBox(height: 50),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // sale image buttons
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(imagePath: 'assets/images/apple-logo.png'),

                    SizedBox(width: 25),

                    // apple button
                    SquareTile(imagePath: 'assets/images/google.png'),
                  ],
                ),

                const SizedBox(height: 50),

                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You Already Have An Account?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  customText() {}
}

class FirebaseService {
   DatabaseReference get dbRef {
    return FirebaseDatabase.instance.ref();
  }
}
