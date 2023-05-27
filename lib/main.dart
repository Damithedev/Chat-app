import 'package:chatapp/pages/chatpage.dart';
import 'package:chatapp/pages/contacts.dart';
import 'package:chatapp/pages/home.dart';
import 'package:chatapp/pages/phoneregister.dart';
import 'package:chatapp/pages/splashscreen.dart';
import 'package:chatapp/pages/spotihyui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/pages/login.dart';
import 'components/User.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  final navigatorKey = GlobalKey<NavigatorState>();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase
      .initializeApp(); // Call Firebase.initializeApp() before using Firebase services

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission();

  final fcmToken = await messaging.getToken();
  print("This is $fcmToken");

  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  ZegoUIKit().initLog().then(
    (value) {
      ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
        [ZegoUIKitSignalingPlugin()],
      );
      runApp(MaterialApp(
        navigatorKey: navigatorKey,
        builder: (context, child) => Stack(
          children: [
            child!,
            ZegoUIKitPrebuiltCallMiniOverlayPage(contextQuery: () {
              return navigatorKey.currentState!.context;
            })
          ],
        ),
        debugShowCheckedModeBanner: false,
        home: Splashscreen(),
      ));
    },
  );
}
