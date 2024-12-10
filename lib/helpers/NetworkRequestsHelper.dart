import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkRequestsHelper{

  static Future<http.Response> postData(String apiUrl, {Object? bodyJson}) async {
    try {
      print("postData is...'");
      print("postData is '${jsonEncode(bodyJson)}'");
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
      throw Exception('Failed to post data ${e}');
      // setState(() {
      //   result = 'Error: $e';
      // });
    }
  }

  static Future<http.Response> getData(String apiUrl) async {
    try {
      final response = await http.get(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get data for request with the url "${apiUrl}" - ${e.toString()}');
    }
  }


}