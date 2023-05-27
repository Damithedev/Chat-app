import 'package:chatapp/components/SharedPrefsUtil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/pages/chatpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnlineUsers extends StatelessWidget {
  const OnlineUsers({super.key});

  @override
  Widget build(BuildContext context) {
    var uid;
    return StreamBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length < 1) {
              return Center(
                child: Text("nobody is online"),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Users(
                  name: 'name',
                  phonenumber: snapshot.data.docs[index].id,
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('status', isEqualTo: 'Online')
            .where('phoneNumber',
                isNotEqualTo: FirebaseAuth.instance.currentUser!.phoneNumber)
            .snapshots());
  }
}

class Users extends StatelessWidget {
  final String phonenumber;
  final String name;
  const Users({super.key, required this.phonenumber, required this.name});

  @override
  Widget build(BuildContext context) {
    String picture = '';
    FirebaseFirestore.instance
        .collection('users')
        .doc(phonenumber)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;
        picture = data['pictureLink'];
      } else {
        print('Document does not exist!');
      }
    });
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green,
              radius: 32,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  picture,
                ),
              ),
            ),
            Text(
              name.length > 10 ? '${name.substring(0, 10)}...' : name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }
}

class RecentChatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecentUser>>(
      future: SharedPrefsUtil.getRecentUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<RecentUser> recentUsers = snapshot.data!;
          return ListView.builder(
            itemCount: recentUsers.length,
            itemBuilder: (context, index) {
              RecentUser user = recentUsers[index];
              // Build UI for displaying recent chats
              // ...
              return Recentchats(
                  contactname: user.username,
                  lastmessage: user.lastMessage,
                  phonenumber: user.phoneNumber
                  // ...
                  );
            },
          );
        }
      },
    );
  }
}

class Recentchats extends StatelessWidget {
  final String contactname;
  final String lastmessage;
  final String phonenumber;
  const Recentchats(
      {super.key,
      required this.lastmessage,
      required this.contactname,
      required this.phonenumber});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => Chatscreen(
                      friendnumber: phonenumber,
                      name: contactname,
                      pic: '',
                    )),
            (route) => false);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      NetworkImage('https://i.ibb.co/Y0wN8tc/7309681.jpg'),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 17),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contactname,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 7.0),
                          child: Text(
                            lastmessage.length > 30
                                ? '${lastmessage.substring(0, 30)}...'
                                : lastmessage,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('yesterday'),
                    Padding(
                      padding: const EdgeInsets.only(top: 7.0),
                      child: Icon(
                        Icons.send,
                        color: Colors.blue,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
