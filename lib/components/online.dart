import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class Database {
  var phonenum = FirebaseAuth.instance.currentUser!.phoneNumber;
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();

  updateUserPresence() async {
    Map<String, dynamic> presenceStatusTrue = {
      'online': true,
      'last_seen': DateTime.now().millisecondsSinceEpoch,
    };

    await databaseReference
        .child(phonenum!)
        .update(presenceStatusTrue)
        .whenComplete(() => print('Updated your presence.'))
        .catchError((e) => print(e));

    Map<String, dynamic> presenceStatusFalse = {
      'presence': false,
      'last_seen': DateTime.now().millisecondsSinceEpoch,
    };

    databaseReference
        .child(phonenum!)
        .onDisconnect()
        .update(presenceStatusFalse);
  }
}
