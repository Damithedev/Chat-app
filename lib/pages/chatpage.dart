import 'dart:convert';
import 'package:chatapp/components/SharedPrefsUtil.dart';
import 'package:chatapp/pages/Videocall.dart';
import 'package:chatapp/pages/callpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/pages/home.dart';
import 'package:chatapp/components/singlemessage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class Chatscreen extends StatefulWidget {
  final String name;
  final String friendnumber;
  final String pic;

  const Chatscreen(
      {super.key,
      required this.name,
      required this.friendnumber,
      required this.pic});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  String? Currentphone;
  String Chat = '';
  bool? isRead;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    color: Color.fromARGB(246, 0, 213, 255),
                  ),
                  child: Icon(
                    Icons.call,
                    color: Color.fromARGB(255, 0, 71, 130),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    color: Color.fromARGB(246, 0, 213, 255),
                  ),
                  child: InkWell(
                    onTap: () {
                      ZegoSendCallInvitationButton(
                        isVideoCall: true,
                        resourceID:
                            "zegouikit_call", // For offline call notification
                        invitees: [
                          ZegoUIKitUser(
                            id: widget.friendnumber,
                            name: widget.friendnumber,
                          ),
                        ],
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Videocall(
                                  friendphone: widget.friendnumber,
                                )),
                      );
                    },
                    child: Icon(
                      Icons.video_call_sharp,
                      color: Color.fromARGB(255, 0, 71, 130),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                (route) => false);
          },
        ),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.pic),
              ),
            ),
            Text(
              widget.name,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(Currentphone)
                      .collection('messages')
                      .doc(widget.friendnumber)
                      .collection('chats')
                      .orderBy("date", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.length < 1) {
                        return Center(
                          child: Text("Say hi"),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            bool isMe = snapshot.data.docs[index]
                                    ['Senderphone'] ==
                                Currentphone;
                            return SingleMessage(
                              message: snapshot.data.docs[index]["message"],
                              isMe: isMe,
                              Currentphone: Currentphone,
                              friendnumber: widget.friendnumber,
                            );
                          });
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  })),
          _buildMessageInput(),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.friendnumber)
        .collection('messages')
        .doc(Currentphone)
        .collection(
            'messages') // assuming messages is the name of the subcollection
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({'isread': isRead});
      });
    });

    isRead = true;
    Currentphone = FirebaseAuth.instance.currentUser!.phoneNumber;
  }

  Widget _buildMessage(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(Chat),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      color: Color.fromARGB(255, 231, 227, 227),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 5,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type a message',
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.blue,
            ),
            onPressed: () async {
              Chat = _controller.text;
              SharedPrefsUtil.addRecentUser(
                  widget.friendnumber, widget.name, _controller.text);

              _controller.clear();
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(Currentphone)
                  .collection('messages')
                  .doc(widget.friendnumber)
                  .collection('chats')
                  .add({
                "Senderphone": Currentphone,
                "Friendphone": widget.friendnumber,
                "message": Chat,
                "date": DateTime.now()
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(Currentphone)
                    .collection('messages')
                    .doc(widget.friendnumber)
                    .set({'last_message': Chat});
              });
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.friendnumber)
                  .collection('messages')
                  .doc(Currentphone)
                  .collection('chats')
                  .add({
                "Senderphone": Currentphone,
                "Friendphone": widget.friendnumber,
                "isread": false,
                "message": Chat,
                "date": DateTime.now()
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.friendnumber)
                    .collection('messages')
                    .doc(Currentphone)
                    .set({'last_message': Chat});
              });
            },
          ),
        ],
      ),
    );
  }
}
