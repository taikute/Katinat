import 'dart:convert';

import 'package:flutter/services.dart';
import '../models/product_model.dart';

class ReadData {
  Future<List<ProductModel>> products() async {
    String jsonString =
        await rootBundle.loadString('assets/files/products.json');

    dynamic jsonData = jsonDecode(jsonString);
    var jsonList = jsonData['products'] as List;

    return jsonList.map((e) => ProductModel.fromMap(e)).toList();
  }
}
