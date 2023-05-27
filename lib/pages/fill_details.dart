import 'package:chatapp/pages/home.dart';
import 'package:chatapp/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class filldetails extends StatefulWidget {
  const filldetails({super.key});

  @override
  State<filldetails> createState() => _filldetailsState();
}

class _filldetailsState extends State<filldetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? uid;
  String? phonenum;
  TextEditingController Name = TextEditingController();
  TextEditingController About = TextEditingController();
  uploadinfo() async {
    try {
      await firebasereference.doc(phonenum!).set({
        'name': Name.text,
        'about': About.text,
        'uid': uid,
        'online': true,
        'last_seen': DateTime.now().microsecondsSinceEpoch
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  var firebasereference = FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.black,
            ),
            onPressed: () {
              uploadinfo();
              // add the function to navigate to the previous screen
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Text(
            'Edit Profile',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
        ),
        toolbarHeight: 60,
      ),
      body: ListView(children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(30),
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://i.ibb.co/w6DfN2S/user.png'),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Display Name',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
              TextField(
                controller: Name,
                decoration: InputDecoration(
                  hintText: "Enter Display name",
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 13,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(width: 1, color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(width: 1, color: Colors.grey)),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
              TextField(
                controller: About,
                decoration: InputDecoration(
                  hintText: "About yourself",
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 13,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(width: 1, color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(width: 1, color: Colors.grey)),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Phone Number',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: 700,
                height: 60,
                decoration: BoxDecoration(
                  color: Color.fromARGB(140, 73, 73, 73),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    phonenum!,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    phonenum = FirebaseAuth.instance.currentUser!.phoneNumber;
    uid = FirebaseAuth.instance.currentUser!.uid;
  }
}
