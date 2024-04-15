import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/resourcers/auth_methods.dart';
import 'package:social_app/responsive/mobile_screen_layout.dart';
import 'package:social_app/responsive/responsive_layout.dart';
import 'package:social_app/responsive/web_screen_layout.dart';
import 'package:social_app/screens/login_screen.dart';
import 'package:social_app/utils/colors.dart';
import 'package:social_app/utils/utils.dart';
import 'package:social_app/widgets/text_input_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout())));
    }
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
              height: 24,
            ),

            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64, backgroundImage: MemoryImage(_image!))
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1569173112611-52a7cd38bea9?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHByb2ZpbGV8ZW58MHx8MHx8fDA%3D'),
                      ),
                Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: () => selectImage(),
                        icon: Icon(Icons.add_a_photo)))
              ],
            ),

            SizedBox(
              height: 14,
            ),

            TextFieldInput(
                textEditingController: _usernameController,
                isPass: false,
                hintText: "Enter your Username",
                textInputType: TextInputType.text),

            SizedBox(
              height: 24,
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
                hintText: "Enter your Password",
                textInputType: TextInputType.text),

            SizedBox(
              height: 24,
            ),

            TextFieldInput(
                textEditingController: _bioController,
                isPass: false,
                hintText: "Enter your Bio",
                textInputType: TextInputType.text),

            SizedBox(
              height: 24,
            ),

            //textfield

            //button
            InkWell(
              onTap: () => signUpUser(),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    color: blueColor),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : Text("Sign Up"),
              ),
            ),

            const SizedBox(
              height: 12,
            ),
            Flexible(
              child: Container(),
              flex: 2,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text("Don't have an account?"),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen())),
                  child: Container(
                    child: Text(
                      " Loggin",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
