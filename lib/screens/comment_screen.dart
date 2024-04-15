

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:social_app/model/user.dart';
import 'package:social_app/providers/user_provider.dart';
import 'package:social_app/resourcers/firestore_methods.dart';
import 'package:social_app/utils/colors.dart';
import 'package:social_app/widgets/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final postId;
  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  //final User user = Provider.of<UserProvider>(context).getUser;
  @override
  Widget build(BuildContext context) {

final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Text("Comments"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.postId)
              .collection('comments').orderBy('datePublished',
              descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context, index) => CommentCard(
                    snap: (snapshot.data! as dynamic).docs[index].data()));
          }),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
                radius: 18, backgroundImage: NetworkImage(user.photoUrl)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8.0),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Comment as ${user.username}',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await FirestoreMethods().postComment(
                    widget.postId,
                    _commentController.text,
                    user.uid,
                    user.username,
                    user.photoUrl);
                setState(() {
                  _commentController.text = '';
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: const Text(
                  "Post",
                  style: TextStyle(color: blueColor),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
