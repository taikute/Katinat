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

  bool like(ProductModel other) {
    return other.key == key;
  }

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

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'name': name,
      'price': price,
      'category': category,
      'image': image,
      'bestSeller': bestSeller,
      'des': des,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      key: map['key'],
      name: map['name'],
      price: map['price'],
      category: map['category'],
      image: map['image'],
      bestSeller: map['bestSeller'],
      des: map['des'],
    );
  }
}
