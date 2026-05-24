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
       color: const Color.fromARGB(255, 75, 74, 74),
       borderRadius: BorderRadius.circular(10)
     ),
     child:  TextField(
      obscureText: obscureText,
        controller: controller,
       decoration: InputDecoration(
         border: InputBorder.none,
         hintText: hintText , hintStyle: TextStyle(color: Colors.white),
         contentPadding: EdgeInsets.symmetric(horizontal: 20)
       ),
     ),
    );
  }
}