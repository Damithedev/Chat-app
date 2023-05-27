import 'package:flutter/material.dart';
import 'phoneregister.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 22, 71, 73),
      appBar: AppBar(
        toolbarHeight: 300,
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(90))),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(90)),
              image: DecorationImage(
                  image: AssetImage('images/back2.png'), fit: BoxFit.fill)),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 21),
            child: Text(
              "A chatting app is a digital platform Where people can connect and chat non-stop, it offers features like messaging and calling And allows users to share files and photos with ease One can stay in touch with friends and family Or meet new people and expand their sociality",
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 23),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Phonereg()));
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(255, 22, 71, 73),
                      fontWeight: FontWeight.bold),
                ),
              ),
              style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  primary: Color.fromARGB(240, 225, 173, 1)),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Help?",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromARGB(240, 225, 173, 1),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.vertical(top: Radius.circular(190)),
        ),
      ),
    );
  }
}
