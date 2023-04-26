import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Compiler extends GetxController {
  String? res;

  final url = Uri.parse(
      "https://api.hackerearth.com/v4/partner/code-evaluation/submissions/");

  final API_KEY = 'cab9402a3f1e18eb8f7516e7be8cc1218fed9192';

  Future<bool> getData(String code, String lang) async {
    var body = {
      "lang": lang,
      "source": code,
    };
    var headers = {
      "client-secret": API_KEY,
    };

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      print(response);
      if (response.statusCode == 200) {
        String he_id = jsonDecode(response.body)['he_id'];
        String status_url = jsonDecode(response.body)['status_update_url'];
        bool completed = false;
        while (!completed) {
          var statusResponse =
              await http.get(Uri.parse(status_url), headers: headers);
          print(statusResponse);
          if (statusResponse.statusCode == 200) {
            String status = jsonDecode(statusResponse.body)['result']
                ['run_status']['status'];
            if (status == 'AC' ||
                status == 'CE' ||
                status == 'RE' ||
                status == 'TLE' ||
                status == 'MLE') {
              String fileUrl = jsonDecode(statusResponse.body)['result']
                  ['run_status']['output'];
              // Make a GET request to the URL of the output file
              var fileResponse = await http.get(Uri.parse(fileUrl));
              if (fileResponse.statusCode == 200) {
                // Set the res variable to the content of the file
                res = fileResponse.body;
                print(res);
                completed = true;
              }
            }
          }
          await Future.delayed(Duration(seconds: 1));
        }
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
