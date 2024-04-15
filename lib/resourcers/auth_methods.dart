

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:social_app/model/user.dart' as model;
import 'package:social_app/resourcers/storage_method.dart';


class AuthMethods{
   
   final FirebaseAuth _auth = FirebaseAuth.instance;
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   Future<model.User> getUserDetails()async{
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fronSnap(snap);
   }

   //sign up

   Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file
    })async{

      //print('data to signup');
       
       String res = "Some error ocured";
       try{
        // ignore: unnecessary_null_comparison
        if(email.isNotEmpty  && password.isNotEmpty  && username.isNotEmpty  && bio.isNotEmpty && file != null){

          UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        // if(cred.user==null) return 'Error';

         
         String photoUrl =
            await StorageMethods().uploadImageToStorage('profilePics', file, false);
       
          model.User user = model.User(
            username: username,
            uid: cred.user!.uid,
            email: email,
            bio: bio,
            followers: [],
            following: [],
            photoUrl: photoUrl

          );

          //add user to database
          await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

          res = "Success";
          
        }else{
          res = "enter all fields";
        }

       } catch(err){
        res = err.toString();

       }
     
      return res; 
   }



   //logging user
   Future<String> logingUser({
    required String email,
    required String password,
   })async{

    String  res = "Some error occured";
    try{
      if(email.isNotEmpty && password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "Success";
      }

    }catch(err){
      res = err.toString();
    }
      return res;
   }

   Future<void> signOut()async{
   await _auth.signOut();
   }
}