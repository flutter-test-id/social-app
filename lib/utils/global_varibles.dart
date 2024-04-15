//import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:flutter/cupertino.dart';
import 'package:social_app/screens/addpost_screen.dart';
import 'package:social_app/screens/feed_screen.dart';
import 'package:social_app/screens/profile_screen.dart';
import 'package:social_app/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
          FeedScreen(),
          SearchScreen(),
          AddPostScreen(),
          Text("notifcation"),
          ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];