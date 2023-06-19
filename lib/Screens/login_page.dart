import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:obida_app/Screens/sign_up.dart';

import '../components/my_button.dart';
import '../components/square_tile.dart';
import 'home_page.dart';
import '../models/Users.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email, password;
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var SignedIn = false;
  var UserID;
  late List<String> collections;
  Users user = Users();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
  void getCollections() {
  DatabaseReference reference = FirebaseDatabase.instance.ref();
  reference.child('Products').once().then((DatabaseEvent event) {
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null) {
      Map<dynamic, dynamic> data = snapshot.value as Map;
       collections = data.keys.cast<String>().toList();
      print(collections); // List of collection names (child nodes) under 'Products'
    }
  });
}

  @override
  Widget build(BuildContext context) {
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
                const ImageIcon(
                  AssetImage('assets/images/saleicon.png'),
                  size: 100,
                ),
                const SizedBox(height: 50),
                Text(
                  'Welcome back, you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value!;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Reset Password'),
                            content: TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                hintText: 'Enter your email',
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  String email = emailController.text.trim();
                                  resetPassword(email);
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Email Sent'),
                                        content: const Text(
                                            'A password reset link has been sent to your email address.'),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors
                                                  .black, // Düğme rengi siyah
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Reset Password'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.black, // Düğme rengi siyah
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                
                //Sign In Button
                SignInButton(
                  onTap: () async {
                    getCollections();
                    
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      try {
                        var userResult = await auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        UserID = userResult.user!.uid;
                        print(UserID);
                        SignedIn = true;
                      } catch (e) {
                        print(e.toString());
                      }
                    }
                    if (SignedIn) {
                      print('signed in ');
                      // ignore: unused_local_variable
                      
                      user.CreateUser(UserID);
                      user.createAdress();
                      
                      user.getAllProducts();
                      print(collections);
                     

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(user: user, collections: collections,)),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[600],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(imagePath: 'assets/images/apple-logo.png'),
                    const SizedBox(width: 25),
                    SquareTile(imagePath: 'assets/images/google.png'),
                  ],
                ),
                const SizedBox(height: 50),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
