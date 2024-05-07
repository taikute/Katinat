import 'package:firebase_database/firebase_database.dart';

class ProductModel {
  final String key;
  final String name;
  final int price;
  final String category;
  final String image;
  final bool bestSeller;
  String? des;

  ProductModel({
    required this.key,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
    required this.bestSeller,
    this.des,
  });

  factory ProductModel.fromSnapShot(DataSnapshot snapshot) {
    final map = snapshot.value as Map;
    return ProductModel(
      key: snapshot.key!,
      name: map['name'],
      des: map['des'],
      image: map['image'],
      price: map['price'],
      category: map['category'],
      bestSeller: map['best_seller'] ?? false,
    );
  }
}
