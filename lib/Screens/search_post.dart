import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:obida_app/Screens/home_page.dart';
import 'package:obida_app/Screens/login_page.dart';



class SearchPost extends StatefulWidget {
  @override
  State<SearchPost> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<SearchPost> {
  @override
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
        title: TextField(
          onChanged: (textEntered){

          },
          decoration: InputDecoration( 
          hintText: "Search Post Here...",
          hintStyle: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: Colors.black,),
            onPressed: (){
              
            },),
            prefixIcon: IconButton(
              icon: Padding(
                padding: EdgeInsets.only(right: 12.0, bottom: 4.0),
                child: Icon(Icons.arrow_back, color: Colors.white,),
                 ),
                 onPressed: (){
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()),);
            },
            )
          ),
        ),
      ),
    );
  }
}
