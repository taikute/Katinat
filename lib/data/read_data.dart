import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/product_model.dart';

class ReadData {
  static Future<List<ProductModel>> fetchProducts() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('products').get();
    return snapshot.children.map((e) => ProductModel.fromSnapShot(e)).toList();
  }

  static Future<List<String>> fetchCarouselImages() async {
    final ref = FirebaseDatabase.instance.ref('carousel_urls');
    final snapshot = await ref.get();
    final snapshotValue = snapshot.value;
    if (snapshotValue is List) {
      return snapshotValue.cast<String>();
    }
    return [];
  }

  static Future<String> getDeviceId() async {
    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      return info.id;
    }
    return '';
  }
}
