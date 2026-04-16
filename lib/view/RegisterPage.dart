import 'package:ai_habit_tracker/view/LoginPages.dart';
import 'package:ai_habit_tracker/widget/Glass.dart';
import 'package:ai_habit_tracker/widget/InputWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPages extends StatefulWidget {
  const RegisterPages({super.key});

  @override
  State<RegisterPages> createState() => _RegisterPagesState();
}

class _RegisterPagesState extends State<RegisterPages> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
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

                      Text("Sign Up", style: TextStyle(fontFamily: "Pacifico", fontSize: 40, color: Colors.white),),
                      SizedBox(height: 20,),
                      InputWidget(
                        hintText: "Name",
                        controller: _nameController,
                        obscureText: false,
                      ),
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
                      SizedBox(height: 20,),
                      InputWidget(
                        hintText: "Confirm Password",
                        controller: _confirmPasswordController,
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
                          TextButton(onPressed: () => Get.to(() => const Loginpages()), child: Text("Sign Up", style: TextStyle(color: Colors.white, ),)),
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