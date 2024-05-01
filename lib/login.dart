import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ono/Admin/admin.dart';
import 'package:ono/dashboard.dart';
import 'package:ono/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCredentials {
  final String userEmail;
  final String userPassword;

  LoginCredentials({
    required this.userEmail,
    required this.userPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'userEmail': userEmail,
      'userPassword': userPassword,
    };
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passToggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.red.shade900,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                maxLength: 40, // Maximum length of 30 characters
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.email,
                      color: Color.fromARGB(255, 65, 63, 63)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(
                      r"^[a-zA-Z0-9,a-zA-Z0-9,!#$%&'*+-/=?^_`{|~}]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: passToggle,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.lock_outlined,
                      color: Color.fromARGB(255, 65, 63, 63)),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        passToggle = !passToggle;
                      });
                    },
                    child: Icon(passToggle
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  } else if (value.length > 20) {
                    return 'Password must be less than 20 characters';
                  } else if (value.contains(' ')) {
                    return 'Password cannot contain spaces';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    LoginCredentials credentials = LoginCredentials(
                      userEmail: _emailController.text,
                      userPassword: _passwordController.text,
                    );
                    String jsonData = jsonEncode(credentials.toJson());
                    try {
                      http.Response response = await http.post(
                        Uri.parse("http://3.6.109.119:4040/qp/login"),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonData,
                      );
                      print(response);
                      var res = json.decode(response.body);
                      print(res);


                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString('response', json.encode(res));

                      var message = res['message'];
                      print(message);
                      bool status = res['status'];
                      if (status) {
                        bool userStatus = res['body']['userStatus'];
                        if (userStatus) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Adminpage(),
                            ),
                          );
                        } else {
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          await prefs.setString(
                              'email', _emailController.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Dashboard(),
                            ),
                          );
                        }
                      } else {
                        String error="Invalid Email or Password ";
                        _showErrorSnackBar(context, error, _formKey);
                      }
                    } catch (e) {
                      print('Error: $e');
                    }
                  }
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade900,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(
      BuildContext context, String error, GlobalKey<FormState> formKey) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.error, color: Colors.white),
          SizedBox(width: 10),
          Text(
            error,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Highlight the respective text field with red border
    formKey.currentState?.validate();
  }
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late String email;

  @override
  void initState() {
    super.initState();
    getEmailFromSharedPreferences();
  }

  Future<void> getEmailFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? '';
    });
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email'); // Remove the stored email
    Navigator.pushReplacement( // Navigate back to login page
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout, // Call the logout method when pressed
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Email from Shared Preferences:',
            ),
            Text(
              email,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class Demo {
  Future<void> sai() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email') ?? '';

    // Create a JSON object containing the email
    Map<String, dynamic> jsonData = {
      'email': email,
    };

    // Convert the JSON object to a string
    String jsonString = jsonEncode(jsonData);

    // Replace 'your_backend_endpoint' with the actual URL of your backend endpoint
    var url = Uri.parse('http://3.6.109.119:4040/qp/signup');

    // Send the JSON string to the backend using HTTP POST request
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonString,
    );

    print('Email sent to backend successfully!');
  }
}

