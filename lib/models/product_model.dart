class ProductModel {
  String? name;
  int? price;
  String? image;

  ProductModel({
    this.name,
    this.price,
    this.image,
  });

  ProductModel.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    price = int.parse(map['price']);
    image = map['image'];
  }

  @override
  String toString() =>
      'ProductModel(name: $name, price: $price, image: $image)';
}
