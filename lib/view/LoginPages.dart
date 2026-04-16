import 'package:ai_habit_tracker/view/RegisterPage.dart';
import 'package:ai_habit_tracker/widget/Glass.dart';
import 'package:get/get.dart';
import 'package:ai_habit_tracker/widget/InputWidget.dart';
import 'package:flutter/material.dart';

class Loginpages extends StatefulWidget {
  const Loginpages({super.key});

  @override
  State<Loginpages> createState() => _LoginpagesState();
}

class _LoginpagesState extends State<Loginpages> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                theWidth: MediaQuery.of(context).size.width * 0.75,
                theHeight: MediaQuery.of(context).size.height * 0.9,
                theChild: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text("Sign In", style: TextStyle(fontFamily: "Pacifico", fontSize: 40, color: Colors.white),),
                      SizedBox(height: 20,),
                      InputWidget(
                        hintText: "Email",
                        controller: _emailController,
                        obscureText: false,
                      ),
                      SizedBox(height: 20,),
                      InputWidget(
                        hintText: "Password",
                        controller: _passwordController,
                        obscureText: true,
                      ),
                      SizedBox(height: 25,),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,                        
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: Colors.white
                          )
                          ),
                        ),onPressed: (){}, child: Text("Sign In", style: TextStyle(color: Colors.white),)),

                      
                      ),
                      SizedBox(height: 10,),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Dont Have an Account?", style: TextStyle(color: Colors.white, ),),
                          TextButton(onPressed: () => Get.to(() => const RegisterPages()), child: Text("Sign In", style: TextStyle(color: Colors.white),)),
                        ],
                      )
                    ],
                  ),
                ),
                
                
              )
            ],
        ),

      ),      
    );
  }
}