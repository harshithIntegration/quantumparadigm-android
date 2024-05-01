import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Service {
  //create the method to save user

  Future<http.Response> saveUser(
      String userName,
      String userEmail,
      String userPhone,
      String userPassword,
      ) async {
    //create uri
    var uri = Uri.parse("http://3.6.109.119:4040/qp/signup");

    //header
    Map<String, String> headers = {"Content-Type": "application/json"};
    //body
    Map data = {
      'userName': '$userName',
      'userEmail': '$userEmail',
      'userPhone': '$userPhone',
      "userPassword": '$userPassword',
    };
    //convert the above data into json
    var body = json.encode(data);
    print(body);
    var response = await http.post(uri, headers: headers, body: body);
    print("${response.body}");

    return response;
  }

  checkUserExists(String text, String text2) {}
}
