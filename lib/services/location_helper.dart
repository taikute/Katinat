import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

class LocationHelper {
  static const apiKey = '1c0c9aac36384586832dd24eb30c84e2';
  static const baseUrl = 'https://api.opencagedata.com/geocode/v1/json?q=';

  static Future<String?> getLocationName(Position position) async {
    final query = '${position.latitude}+${position.longitude}';
    final response =
        await get(Uri.parse('$baseUrl$query&key=$apiKey&roadinfo=1'));
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final results = jsonResponse['results'] as List;
    if (results.isEmpty) {
      return null;
    }
    final result = results.first;
    return result['formatted'];
  }
}
