import 'package:firebase_database/firebase_database.dart';

class ProductModel {
  final String key;
  final String name;
  final int price;
  final String image;
  String? des;

  ProductModel({
    required this.key,
    required this.name,
    required this.price,
    required this.image,
    this.des,
  });

  factory ProductModel.fromSnapShot(DataSnapshot snapshot) {
    final map = snapshot.value as Map;
    return ProductModel(
      key: snapshot.key!,
      name: map['name'] as String,
      des: map['des'] != null ? map['des'] as String : null,
      image: map['image'] as String,
      price: map['price'] as int,
    );
  }
}
