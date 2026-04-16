import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({
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

       color: Colors.transparent,
       borderRadius: BorderRadius.circular(20)
     ),
     child:  TextField(
      obscureText: obscureText,
        controller: controller,
       decoration: InputDecoration(
         border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
         ),
         enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white)
         ),
         hintText: hintText , hintStyle: TextStyle(color: Colors.white),
         contentPadding: EdgeInsets.symmetric(horizontal: 20)
       ),
     ),
    );
  }
}