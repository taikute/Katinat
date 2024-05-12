import 'package:flutter/foundation.dart';
import 'product_model.dart';
import '../services/currency_convert.dart';

class ProductDetailModel {
  final ProductModel product;
  List<Topping> toppings = [];
  SugarLevel sugarLevel;
  IceLevel iceLevel;
  int quantity;
  String? note;

  int get totalPrice {
    int price = product.price;
    for (final topping in toppings) {
      price += topping.price;
    }
    return price;
  }

  String get totalPriceVND {
    return CurrencyConvert.toVND(totalPrice);
  }

  String get noteString {
    String stringBuilder = '';
    if (toppings.isNotEmpty) {
      stringBuilder += 'Topping: ';
      stringBuilder += toppings.map((topping) => topping.name).join(', ');
    }
    if (sugarLevel.index != 0) {
      stringBuilder += '\n';
      stringBuilder += 'Sugar: ';
      stringBuilder += sugarLevel.name;
    }
    if (iceLevel.index != 0) {
      stringBuilder += '\n';
      stringBuilder += 'Ice: ';
      stringBuilder += iceLevel.name;
    }
    if (note != null) {
      stringBuilder += '\n';
      stringBuilder += 'Note: ';
      stringBuilder += note!;
    }
    return stringBuilder;
  }

  ProductDetailModel(
    this.product, {
    required this.toppings,
    this.sugarLevel = SugarLevel.oneHundredPercent,
    this.iceLevel = IceLevel.normal,
    this.quantity = 1,
    this.note,
  });

  bool like(ProductDetailModel other) {
    return other.product.like(product) &&
        listEquals(other.toppings, toppings) &&
        other.sugarLevel == sugarLevel &&
        other.iceLevel == iceLevel &&
        other.note == note;
  }

  factory ProductDetailModel.fromMap(Map<String, dynamic> map) {
    return ProductDetailModel(
      ProductModel.fromMap(map['product']),
      toppings: (map['toppings'] as List)
          .map((index) => Topping.values[index])
          .toList(),
      sugarLevel: SugarLevel.values[map['sugar_level']],
      iceLevel: IceLevel.values[map['ice_level']],
      quantity: map['quantity'],
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'toppings': toppings.map((topping) => topping.index).toList(),
      'sugar_level': sugarLevel.index,
      'ice_level': iceLevel.index,
      'quantity': quantity,
      'note': note,
    };
  }
}

enum Topping {
  cheesePearl('Cheese Pearl', 10000),
  caramelBubble('Caramel Bubble', 10000),
  jumboCheeseBall('Jumbo Cheese Ball', 10000),
  caramelFlan('Caramel Flan', 15000);

  final String name;
  final int price;
  const Topping(this.name, this.price);
}

enum SugarLevel {
  oneHundredPercent('100%'),
  fiftyPercent('50%'),
  thirdtyPercent('30%'),
  zeroPercent('0%');

  final String name;
  const SugarLevel(this.name);
}

enum IceLevel {
  normal('Normal'),
  lessIce('Less Ice'),
  moreIce('More Ice'),
  noIce('No Ice');

  final String name;
  const IceLevel(this.name);
}
