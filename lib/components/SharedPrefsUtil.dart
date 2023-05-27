import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RecentUser {
  final String phoneNumber;
  final String username;
  final String lastMessage;

  RecentUser(this.phoneNumber, this.username, this.lastMessage);

  // Convert RecentUser object to JSON
  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'username': username,
      'lastMessage': lastMessage,
    };
  }

  // Create RecentUser object from JSON
  factory RecentUser.fromJson(Map<String, dynamic> json) {
    return RecentUser(
      json['phoneNumber'],
      json['username'],
      json['lastMessage'],
    );
  }
}

class SharedPrefsUtil {
  static const String keyRecentChats = 'recentChats';

  static Future<List<RecentUser>> getRecentUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? recentUsersJson = prefs.getStringList(keyRecentChats);
    if (recentUsersJson != null) {
      List<RecentUser> recentUsers = recentUsersJson
          .map((json) =>
              RecentUser.fromJson(jsonDecode(json) as Map<String, dynamic>))
          .toList();
      return recentUsers;
    } else {
      return [];
    }
  }

  static Future<void> addRecentUser(
      String phoneNumber, String username, String lastMessage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<RecentUser> recentUsers = await getRecentUsers();

    // Remove any existing recent user with the same phone number
    recentUsers.removeWhere((user) => user.phoneNumber == phoneNumber);

    // Add the new recent user to the beginning of the list
    recentUsers.insert(0, RecentUser(phoneNumber, username, lastMessage));

    // Limit the list to a certain number of recent users, e.g., 10
    if (recentUsers.length > 10) {
      recentUsers = recentUsers.sublist(0, 10);
    }

    // Save the updated list to shared preferences
    List<String> recentUsersJson =
        recentUsers.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList(keyRecentChats, recentUsersJson);
  }
}
