import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String email;
  late final String userName;
  late final String userEmail;// Should be hashed and not stored plain-text
  late final int userMobile;

  User({
    required this.email,
    required this.userName,
    required this.userEmail,
    required this.userMobile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'].toString(),
      userName: json['userName'] ?? '',
      userEmail: json['userEmail'] ?? '',
      userMobile: json['userMobile'] ?? 0,
    );
  }

  static Future<User> fetchUserByEmail(String email) async {
    final response = await http.post(
      Uri.parse('http://3.6.109.119:4040/qp/login'),
      body: {'email': email},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);
      return User.fromJson(userData);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
