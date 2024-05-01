import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ono/dashboard.dart';

class Committee1Page extends StatefulWidget {
  @override
  _Committee1PageState createState() => _Committee1PageState();
}

class _Committee1PageState extends State<Committee1Page> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> userList = [];
  List<dynamic> originalUserList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final String apiUrl = 'http://3.6.109.119:4040/admin/fetchAllCommitte';

    try {
      final http.Response response = await http.get(Uri.parse(apiUrl));
      var data = jsonDecode(response.body);
      setState(() {
        userList = data['userList'];
        originalUserList = List.from(userList);
      });
    } catch (e) {
      print('Failed to load data: $e');
    }
  }

  void _filterMembers(String query) {
    List<dynamic> filteredList = originalUserList.where((member) {
      String name = member['userName'].toString().toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      userList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Committee Members'),
        centerTitle: true,
        backgroundColor: Colors.red.shade900,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Dashboard(),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search members...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: _filterMembers,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildMember(userList[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMember(Map<String, dynamic> member, int index) {
    String name = member['userName'];
    String designation = member['userPosition'];
    String imagePath = member['imagePath'] ?? 'assets/avatar.png';

    Widget avatarWidget;

    avatarWidget = CircleAvatar(
      radius: 30,
      backgroundImage: AssetImage(imagePath),
    );

    return ListTile(
      leading: GestureDetector(
        child: avatarWidget,
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        designation,
        style: TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }
}
