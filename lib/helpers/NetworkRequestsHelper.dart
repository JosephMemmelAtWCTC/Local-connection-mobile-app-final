import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:local_connection_first/helpers/NetworkRequestsHelper.dart';

class NetworkRequestsHelper{

  static Future<http.Response> postData(String apiUrl, {Object? bodyJson}) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(bodyJson) //jsonEncode(<String, dynamic>{
      );

      // if (response.statusCode >= 200 && response.statusCode < 300) {
        // Successful POST request, handle the response here
        // final responseData = jsonDecode(response.body);
        // // setState(() {
        // //   result = 'ID: ${responseData['id']}\nName: ${responseData['name']}\nEmail: ${responseData['email']}';
        // // });
        // 1+1;
      return response;
      // } else {
      //   // If the server returns an error response, throw an exception
      //   throw Exception('Failed to post data');
      // }
    } catch (e) {
      throw Exception('Failed to post data');
      // setState(() {
      //   result = 'Error: $e';
      // });
    }
  }


}