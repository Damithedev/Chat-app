import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SingleMessage extends StatefulWidget {
  final String message;
  final bool isMe;
  final Currentphone;
  final friendnumber;
  const SingleMessage(
      {super.key,
      required this.message,
      required this.isMe,
      required this.Currentphone,
      required this.friendnumber});

  @override
  State<SingleMessage> createState() => _SingleMessageState();
}

class _SingleMessageState extends State<SingleMessage> {
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        setState(() {
          highlighted = true;
        });
      },
      onTap: () {
        setState(() {
          highlighted = false;
        });
      },
      child: Row(
        mainAxisAlignment:
            widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (highlighted)
            Row(
              children: [
                Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(
                        left: 16, right: 3, top: 16, bottom: 16),
                    constraints: BoxConstraints(maxWidth: 200),
                    decoration: BoxDecoration(
                        color: widget.isMe ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: widget.isMe ? Colors.white : Colors.black,
                      ),
                    )),
                GestureDetector(
                  onTap: () async {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.Currentphone)
                        .collection('messages')
                        .doc(widget.friendnumber)
                        .collection('chats')
                        .where('message', isEqualTo: widget.message)
                        .get()
                        .then((QuerySnapshot snapshot) {
                      snapshot.docs.forEach((doc) {
                        doc.reference.delete();
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.Currentphone)
                            .collection('messages')
                            .doc(widget.friendnumber)
                            .set({'last_message': 'Message was deleted'});
                      });
                    });
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.friendnumber)
                        .collection('messages')
                        .doc(widget.Currentphone)
                        .collection('chats')
                        .where('message', isEqualTo: widget.message)
                        .get()
                        .then((QuerySnapshot snapshot) {
                      snapshot.docs.forEach((doc) {
                        doc.reference.delete();
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.friendnumber)
                            .collection('messages')
                            .doc(widget.Currentphone)
                            .set({'last_message': 'Message was deleted'});
                      });
                    });

                    print("nice");
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 247, 16, 0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Icon(Icons.delete),
                  ),
                )
              ],
            )
          else
            Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(16),
                constraints: BoxConstraints(maxWidth: 200),
                decoration: BoxDecoration(
                    color: widget.isMe ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Text(
                  widget.message,
                  style: TextStyle(
                    color: widget.isMe ? Colors.white : Colors.black,
                  ),
                )),
        ],
      ),
    );
  }
}
