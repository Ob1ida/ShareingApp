import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/square_tile.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  late String name, surname, email, password;
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;

  // text editing controllers
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user up method
  void signUpUser() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        var userResult = await firebaseAuth.createUserWithEmailAndPassword(
          name: name,
          surname: surname,
          email: email,
          password: password,
        );
        print(userResult.user!.uid);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
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
                      return 'Please enter your name';
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

                // surname textfield
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your surname';
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
                      return 'Please enter your email';
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
                      return 'Please enter your password';
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
                SignInButton(
                  onTap: signUpUser,
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
                Row(
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

            
              ],
            ),
          ),
        ),
      ),
    );
  }
}
