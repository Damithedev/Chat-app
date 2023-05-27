import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatapp/pages/home.dart';
import 'package:chatapp/pages/phoneregister.dart';
import 'package:chatapp/pages/fill_details.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    navigateToNextPage();
  }

  Future<void> navigateToNextPage() async {
    // Add your loading logic here, e.g. load data from a server
    await Future.delayed(Duration(seconds: 3));

    // Check if user is already authenticated and navigate accordingly
    final currentUser = FirebaseAuth.instance.currentUser;

    final prefs = await SharedPreferences.getInstance();

    if (currentUser != null) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Home()), (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Phonereg()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeInDown(
            duration: Duration(seconds: 2),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 27, vertical: 10),
              child: Image.asset(
                'images/logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          FadeIn(
            duration: Duration(seconds: 10),
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
}
