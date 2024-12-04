import 'package:http/http.dart' as http;
import 'dart:convert';


class ResourcesSystem{


  ResourcesSystem();


  static Future<void> postData(String apiUrl) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': "admin@example.com",
          'password': "B@nanas123",
        }),
      );

    } catch (e) {
      rethrow;
    }
  }


}