import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:map/constants.dart';

class BarikoiProvider extends ChangeNotifier {
  String location = 'hi';

  Future<void> getLocation(num? lat, num? lng) async {
    try {
      var response = await http
          .get(
            Uri.parse(
                'https://barikoi.xyz/v1/api/search/reverse/$APIKEY/geocode?longitude=$lng&latitude=$lat&district=true&post_code=true&country=true&sub_district=true&union=true&pauroshova=true&location_type=true&division=true&address=true&area=true'),
          )
          .timeout(const Duration(seconds: 15));

      location = json.decode(response.body)['place']['address'];
      print(location);
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
    }
    notifyListeners();
  }
}

final barikoiProvider = ChangeNotifierProvider<BarikoiProvider>((ref) {
  return BarikoiProvider();
});
