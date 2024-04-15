import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/model/post.dart' ;
import 'package:social_app/resourcers/storage_method.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username, 
    String profImage
  ) async{
    String res = "Some error occoured";
    try{
      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        description: description, 
      uid: uid, 
      username: username, 
      likes: [],
       postId: postId, 
       datePublished: DateTime.now(),
        postUrl: photoUrl,
         profImage: profImage,
         );

         _firestore.collection('posts').doc(postId).set(post.toJson());
         res = "success";

    }catch(err){
       res =err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async{
    try{
      if(likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).update({
          'likes' : FieldValue.arrayRemove([uid])
        });
      }else{
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }

    } catch(e){
      print(e.toString());
    }
  }

  Future<void> postComment(String postId,String text,String uid, String name,String profilePic) async{
    try{
      if(text.isNotEmpty){
        String commentId = const Uuid().v1();
        await _firestore.collection('posts')
        .doc(postId).
        collection('comments')
        .doc(commentId)
        .set({
          'profilePic' : profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished' : DateTime.now()
        });
      }else{
        print('Text is empty');
      }

    }catch(e){
      print(e.toString());

    }
  }

  //deleting the post
  Future<void> deletePost(String postId)async{
    try{
      await _firestore.collection('posts').doc(postId).delete();
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> followUser(
    String uid,
    String followId
  )async{
    try{
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)){
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following' : FieldValue.arrayRemove([followId])
        });

        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }

    } catch(e){
      print(e.toString());
    }
  }
}