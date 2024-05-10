import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../data/read_data.dart';

import '../../services/color_manager.dart';
import '../../widgets/product_card.dart';

class BestSellerWidget extends StatelessWidget {
  static List<ProductCard> cards = [];
  const BestSellerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Text(
                'BEST SELLER',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primaryColor,
                ),
              ),
              Icon(
                Icons.star,
                color: ColorManager.primaryColor,
              ),
              Spacer(),
              Text(
                'See all',
                style: TextStyle(
                  fontSize: 12,
                  color: ColorManager.secondaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Best Seller
        FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            return CarouselSlider(
              items: cards,
              options: CarouselOptions(
                aspectRatio: 1.4,
                viewportFraction: 0.45,
                enlargeCenterPage: true,
                enlargeFactor: 0.2,
              ),
            );
          },
        ),
      ],
    );
  }
}

Future<void> fetchData() async {
  final cards = BestSellerWidget.cards;
  if (cards.isNotEmpty) {
    return;
  }
  final products = await ReadData.fetchProducts();
  final bestSellerProducts =
      products.where((product) => product.bestSeller == true).toList();
  for (final product in bestSellerProducts) {
    final fileInfo = await DefaultCacheManager().downloadFile(product.image);
    cards.add(ProductCard(product: product, imageFile: fileInfo.file));
  }
}
