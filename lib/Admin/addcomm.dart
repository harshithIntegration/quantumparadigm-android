import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPositionController = TextEditingController();
  List<dynamic> userList = [];
  String? responseMessage;
  bool? responseStatus;

  // List of alternative background colors
  final List<Color> avatarColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.blueGrey,
    Colors.brown,
  ];

  // Index to track the color from the avatarColors list
  int colorIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Fetching all users from the database using HTTP request
  void fetchData() async {
    final String apiUrl = 'http://3.6.109.119:4040/admin/fetchAllCommitte';

    try {
      final http.Response response = await http.get(Uri.parse(apiUrl));
      var data = jsonDecode(response.body);
      setState(() {
        userList = data['userList'];
        responseMessage = data['message'];
        responseStatus = data['status'];
      });
      print('Fetch All Members Response: $responseStatus');
    } catch (e) {
      print('Failed to load data: $e');
    }
  }

  // DELETE
  void deleteUser(int userId) async {
    final String apiUrl =
        'http://3.6.109.119:4040/admin/deleteCommitteeUser?userId=$userId';

    try {
      final http.Response response = await http.delete(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        bool status = responseData['status'];

        setState(() {
          responseMessage = responseData['message'];
          responseStatus = status;
        });

        print('Delete Member Response: $responseMessage');
        print('Status: $status');

        if (status) {
          fetchData(); // Refresh data after deletion
        } else {
          throw Exception('Failed to delete member');
        }
      } else {
        throw Exception('Failed to delete member: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to delete member: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Committee'),
        backgroundColor: Colors.red.shade900,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: userNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                maxLength: 30, // Maximum length of 30 characters
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Add Name',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.perm_identity,
                      color: Color.fromARGB(255, 65, 63, 63)),
                ),
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: userPositionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                maxLength: 30, // Maximum length of 30 characters
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Position',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.perm_identity,
                      color: Color.fromARGB(255, 65, 63, 63)),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    String name = userNameController.text.trim();
                    String position = userPositionController.text.trim();
                    if (name.isNotEmpty && position.isNotEmpty) {
                      try {
                        final String apiUrl =
                            'http://3.6.109.119:4040/admin/addCommitteeUser';

                        final http.Response response = await http.post(
                          Uri.parse(apiUrl),
                          body: jsonEncode({
                            'userName': name,
                            'userPosition': position,
                          }),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                        );

                        var responseData = jsonDecode(response.body);
                        setState(() {
                          responseMessage = responseData['message'];
                          responseStatus = responseData['status'];
                        });
                        print('Add Member Response: $responseMessage');
                        print('Status: $responseStatus');

                        if (responseStatus == true) {
                          fetchData(); // Refresh data after adding
                          userNameController.clear();
                          userPositionController.clear();
                        } else {
                          throw Exception('Failed to add member');
                        }
                      } catch (e) {
                        print('Failed to add member: $e');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade900,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 450,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    // Get the current color from the list
                    Color color = avatarColors[colorIndex % avatarColors.length];
                    colorIndex++;

                    return ListTile(
                      title: Text(userList[index]['userName']),
                      subtitle: Text(userList[index]['userPosition']),
                      leading: CircleAvatar(
                        backgroundColor: color,
                        child: Text(
                          userList[index]['userName'][0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Confirm Deletion'),
                                content: Text(
                                    'Are you sure you want to delete this member?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      int id = userList[index]['userId'];
                                      deleteUser(id);

                                      Navigator.pop(context);
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
