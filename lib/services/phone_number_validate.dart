import 'dart:convert';

import 'package:http/http.dart';

class PhoneNumberValidate {
  static const apiKey = 'NF1cWHvZEemgLOh1FvBRew==oTUefjvQwPnHxK8D';
  static const baseUrl = 'https://api.api-ninjas.com/v1/validatephone';

  static Future<bool> isValid(String phoneNumber) async {
    phoneNumber = phoneNumber.replaceFirst('0', '84');
    final url = Uri.parse('$baseUrl?number=$phoneNumber');
    final headers = {'X-Api-Key': apiKey};
    final response =
        await get(url, headers: headers).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (!jsonResponse['is_valid']) return false;
      if (!jsonResponse['is_formatted_properly']) return false;
      if (jsonResponse['country'] != 'Vietnam') return false;
      if (jsonResponse['location'] != 'Vietnam') return false;
      if (jsonResponse['location'] != 'Vietnam') return false;
      if (!(jsonResponse['timezones'] as List<dynamic>)
          .contains('Asia/Bangkok')) {
        return false;
      }
      return true;
    }
    return false;
  }
}
