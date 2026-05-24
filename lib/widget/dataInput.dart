import 'package:flutter/material.dart';

class dataInputWidget extends StatelessWidget {
  const dataInputWidget({
    super.key, required this.hintText, required this.controller, required this.obscureText
  });

  final String hintText;
  final TextEditingController controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
     width: double.infinity,
     
     decoration: BoxDecoration(
       color: const Color.fromARGB(255, 255, 255, 255),
       borderRadius: BorderRadius.circular(10)
     ),
     child:  TextField(
      obscureText: obscureText,
        controller: controller,
       decoration: InputDecoration(
         border: InputBorder.none,
         hintText: hintText , hintStyle: TextStyle(color: const Color.fromARGB(255, 125, 117, 117)),
         contentPadding: EdgeInsets.symmetric(horizontal: 20)
       ),
     ),
    );
  }
}