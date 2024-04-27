import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/product_model.dart';

class ReadData {
  static Future<List<ProductModel>> fetchProducts() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('products').get();
    return snapshot.children.map((e) => ProductModel.fromSnapShot(e)).toList();
  }

  static Future<List<String>> fetchCarouselImages() async {
    List<String> list = [];
    var listResult =
        await FirebaseStorage.instance.ref('images/carousel_images').listAll();
    for (var item in listResult.items) {
      list.add(await item.getDownloadURL());
    }
    return list;
  }
}
