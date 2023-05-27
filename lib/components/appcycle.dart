import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final DatabaseReference userRef;

  AppLifecycleObserver(this.userRef);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        userRef.update({'status': 'online'});
        break;
      case AppLifecycleState.inactive:
        userRef.update({'status': 'offline'});
        break;
      case AppLifecycleState.paused:
        userRef.update({
          'status': 'offline',
          'last_seen': DateTime.now().millisecondsSinceEpoch,
        });
        break;
      case AppLifecycleState.detached:
        userRef.update({
          'status': 'offline',
          'last_seen': DateTime.now().millisecondsSinceEpoch,
        });
        break;
    }
  }
}
