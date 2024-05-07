import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:katinat/services/init_data.dart';

import '../../services/color_manager.dart';
import '../../widgets/product_card.dart';

class BestSellerWidget extends StatelessWidget {
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
        CarouselSlider(
          items: InitData.bestSellerProducts!.map((product) {
            return ProductCard(product: product);
          }).toList(),
          options: CarouselOptions(
            aspectRatio: 1.4,
            viewportFraction: 0.45,
            enlargeCenterPage: true,
            enlargeFactor: 0.2,
          ),
        ),
      ],
    );
  }
}
