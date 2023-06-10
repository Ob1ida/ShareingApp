import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:obida_app/Screens/sign_up.dart';
import 'package:obida_app/components/my_button.dart';
import 'package:obida_app/components/my_textfield.dart';
import 'package:obida_app/components/square_tile.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  late String email, password;
  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Form(
            key:formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
          
                // logo
                ImageIcon(AssetImage('assets/images/saleicon.png'
                ),
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
                  validator: (value){
                    if(value!.isEmpty){
                      return "please Enter your Email";
                    }
                    else{
          
                    }
                  },
                  onSaved: (value){
                    email = value!;
                  },
                  controller: usernameController,
                  decoration: const InputDecoration(
                  hintText: 'Email',
                  ),
                  obscureText: false,
                ),
          
                const SizedBox(height: 10),
          
                // password textfield
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return "please Enter your Password";
                    }
                    else{
          
                    }
                    
                  },
                  onSaved: (value){
                    password = value!;
                  },
                  controller: passwordController,
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
                  onTap:() async {
                    if(formkey.currentState!.validate()){
                      formkey.currentState!.save();
                      try{
                        var userResult =
                         await firebaseAuth.createUserWithEmailAndPassword(
                          email: email, password: password, name: 'name', surname: 'surname');
                          print(userResult.user!.uid);
                      }catch(e){
                        print(e.toString());
                      }
                      
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