import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_app/resourcers/auth_methods.dart';
import 'package:social_app/screens/signup_screen.dart';
import 'package:social_app/utils/colors.dart';
import 'package:social_app/utils/utils.dart';
import 'package:social_app/widgets/text_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void logingUser()async{
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().logingUser(email: _emailController.text, password: _passwordController.text);
    if(res == "Success"){

    }else{
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(),
              flex: 2,
            ),
            //svg image
            SvgPicture.asset(
              "assets/ic_instagram.svg",
              color: primaryColor,
              height: 64,
            ),
            SizedBox(
              height: 64,
            ),

            //tectfield
            TextFieldInput(
                textEditingController: _emailController,
                isPass: false,
                hintText: "Enter your email",
                textInputType: TextInputType.emailAddress),

            SizedBox(
              height: 24,
            ),

            //textfield
            TextFieldInput(
                textEditingController: _passwordController,
                isPass: true,
                hintText: "Password",
                textInputType: TextInputType.text),

            SizedBox(
              height: 24,
            ),

            //button
            InkWell(

              onTap: () => logingUser(),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                        color: blueColor
                        ),
                child: _isLoading ? const Center(child: CircularProgressIndicator(color: primaryColor,),) : Text("Login"),
                
              ),
            ),

            const SizedBox(height: 12,),
            Flexible(child: Container(),flex: 2,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text("Don't have an account?"),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                 GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>SignupScreen()));
                  },
                   child: Container(
                    child: Text("    Sign Up",style: TextStyle(fontWeight: FontWeight.bold),),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                                   ),
                 ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
