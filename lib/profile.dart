import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ono/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class viewProfilePage extends StatefulWidget {
  const viewProfilePage();

  @override
  _viewProfilePageState createState() => _viewProfilePageState();
}

class _viewProfilePageState extends State<viewProfilePage> {
  late Map<String, dynamic> response;

  @override
  void initState() {
    super.initState();
    response = {}; // Initialize response to an empty map
    fetchStoredResponse();
  }

  Future<void> fetchStoredResponse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedResponse = prefs.getString('response');
    if (storedResponse != null) {
      setState(() {
        response = json.decode(storedResponse);
      });
    } else {
      // Handle the case where no response is stored
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Page',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red.shade900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Dashboard(), // Assuming LoginPage is your login page
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Display user profile information using the `response` variable
              if (response['body'] != null)
                ...[
                  itemProfile('Name', response['body']['userName'], Icons.person),
                  const SizedBox(height: 10),
                  itemProfile('Phone', response['body']['userPhone'].toString(), Icons.phone),
                  const SizedBox(height: 10),
                  itemProfile('Email', response['body']['userEmail'], Icons.email),
                ],
            ],
          ),
        ),
      ),
    );
  }

  Widget itemProfile(String title, String subtitle, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Color.fromARGB(255, 240, 221, 221),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: TextFormField(
          initialValue: subtitle,
          readOnly: true,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
        leading: Icon(icon),
        tileColor: Colors.white,
      ),
    );
  }
}
