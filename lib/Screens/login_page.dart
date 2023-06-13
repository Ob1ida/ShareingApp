import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:obida_app/Screens/sign_up.dart';
import 'package:obida_app/components/my_button.dart';
import 'package:obida_app/components/my_textfield.dart';
import 'package:obida_app/components/square_tile.dart';

import '../models/Users.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email, password;
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var SignedIn = false;
  var UserID;
  
  late DatabaseReference dbRef;

  get firebaseAuth => null;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Users');
  }

// sign user in method
  void signUserIn() {}

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

                // logo
                const ImageIcon(
                  AssetImage('assets/images/saleicon.png'),
                  size: 100,
                ),
                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // username textfield
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "please Enter your Email";
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

                // password textfield
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "please Enter your Password";
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

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                SignInButton(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      try {
                        var userResult =
                            await auth.signInWithEmailAndPassword(email: email, password: password);
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
                     Users user = Users();
                     user.CreateUser(UserID);
                      

                    }
                  },
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
                    SquareTile(imagePath: 'assets/images/google.png')
                  ],
                ),

                const SizedBox(height: 50),

                // not a member? register now
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


