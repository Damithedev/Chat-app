import 'dart:ui';

import 'package:chatapp/components/appcycle.dart';
import 'package:chatapp/pages/contacts.dart';
import 'package:chatapp/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/pages/phoneregister.dart';
import 'package:chatapp/components/onlineusers.dart';
import 'package:firebase_database/firebase_database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  var firebasereference = FirebaseFirestore.instance.collection("users");
  User? user = FirebaseAuth.instance.currentUser;
  String? uid;
  String longText = 'Damilola abiola';
  String dropdownValue = 'online';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(246, 0, 213, 255),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(246, 0, 213, 255),
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu,
              size: 30,
            )),
        title: Container(
            alignment: Alignment.center,
            child: Image.asset(
              width: 30,
              'images/icon.png',
              color: Colors.white,
              height: 30,
              fit: BoxFit.fill,
            )),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Phonereg()));
            },
            child: Icon(
              Icons.logout,
              color: Colors.white,
              size: 26,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 150,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 15),
                  child: Text(
                    'Online',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 117,
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: OnlineUsers(),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50))),
          ),
          Expanded(
              child: Container(
            width: MediaQuery.of(context).size.width,
            child: RecentChatsWidget(),
            color: Colors.white,
          ))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PhoneListScreen()));
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.phoneNumber;

    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update(
        {"status": status, "last_seen": DateTime.now().microsecondsSinceEpoch});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }
}
