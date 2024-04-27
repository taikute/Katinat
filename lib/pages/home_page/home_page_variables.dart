import '../../data/read_data.dart';
import '../../models/product_model.dart';

class HomePageVariables {
  static late List<String> carouselImages;
  static late List<ProductModel> bestSellerProducts;

  static Future<void> updateCarouselImages() async {
    carouselImages = await ReadData.fetchCarouselImages();
  }

  static Future<void> init() async {
    carouselImages = await ReadData.fetchCarouselImages();
    bestSellerProducts = await ReadData.fetchProducts();
  }
}
