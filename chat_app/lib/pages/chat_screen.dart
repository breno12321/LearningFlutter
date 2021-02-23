import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:chat_app/widgets/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  User _currentUser;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((event) {
      _currentUser = event;
    });
  }

  Future<User> _getUser() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential cred = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authRes =
          await FirebaseAuth.instance.signInWithCredential(cred);

      final User user = authRes.user;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _sendMessage({
    String message,
    File img,
  }) async {
    final User user = await _getUser();

    if (user == null) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text("Usuário não autenticado. Tente novamente")));
    }

    Map<String, dynamic> data = {
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoURL": user.photoURL,
    };
    if (img != null) {
      try {
        TaskSnapshot task = await FirebaseStorage.instance
            .ref()
            .child(DateTime.now().millisecondsSinceEpoch.toString())
            .putFile(img);
        String fileURL = await task.ref.getDownloadURL();
        print(fileURL);
        data['imgURL'] = fileURL;
      } catch (e) {
        return;
      }
    }
    data['text'] = message ?? "";

    FirebaseFirestore.instance.collection("messages").add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Chat"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('messages').snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                    break;
                  default:
                    QuerySnapshot documents = snapshot.data;
                    List<QueryDocumentSnapshot> documentsList =
                        documents.docs.reversed.toList();
                    return ListView.builder(
                      itemCount: documentsList.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return ChatMessage(documentsList[index].data());
                      },
                    );
                }
              },
            ),
          ),
          TextComposer(_sendMessage),
        ],
      ),
    );
  }
}
