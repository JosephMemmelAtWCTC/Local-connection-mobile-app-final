import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkRequestsHelper{

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
          // Add any other data you want to send in the body
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Successful POST request, handle the response here
        final responseData = jsonDecode(response.body);
        // setState(() {
        //   result = 'ID: ${responseData['id']}\nName: ${responseData['name']}\nEmail: ${responseData['email']}';
        // });
        1+1;
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to post data');
      }
    } catch (e) {
      // setState(() {
      //   result = 'Error: $e';
      // });
    }
  }


}