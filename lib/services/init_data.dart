import '../data/read_data.dart';
import '../models/product_model.dart';

class InitData {
  static List<String>? carouselImages;
  static List<ProductModel>? products;
  static List<ProductModel>? bestSellerProducts;

  static Future<void> init() async {
    carouselImages = await ReadData.fetchCarouselImages();
    products = await ReadData.fetchProducts();
    bestSellerProducts ??=
        products!.where((product) => product.bestSeller == true).toList();
  }
}
