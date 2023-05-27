import 'dart:async';

import 'package:chatapp/pages/chatpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PhoneListScreen extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Numbers'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final documents = snapshot.data!.docs;
          final phoneNumbers = documents.map((doc) => doc.id).toList();

          return ListView.builder(
            itemCount: phoneNumbers.length,
            itemBuilder: (context, index) {
              final data = documents[index].data() as Map<String, dynamic>?;

              final name = data?['name'];
              final pic = data?['pic'];

              return InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Chatscreen(
                                friendnumber: phoneNumbers[index],
                                name: name,
                                pic: pic ?? 'https://i.ibb.co/w6DfN2S/user.png',
                              )),
                      (route) => false);
                },
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          pic ?? 'https://i.ibb.co/w6DfN2S/user.png')),
                  title: Text(name ?? 'N/A'),
                  subtitle: Text(phoneNumbers[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
