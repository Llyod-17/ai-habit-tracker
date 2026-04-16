import 'package:ai_habit_tracker/widget/Glass.dart';
import 'package:flutter/material.dart';

class Loginpages extends StatefulWidget {
  const Loginpages({super.key});

  @override
  State<Loginpages> createState() => _LoginpagesState();
}

class _LoginpagesState extends State<Loginpages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover
            )
          ),

        child: Stack(
            children: [
              Glass(
                theWidth: MediaQuery.of(context).size.width,
                theHeight: MediaQuery.of(context).size.height,
                theChild: Text("Login Pages"),
              )
            ],
        ),

      ),
      
      

      
    );
  }
}