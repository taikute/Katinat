import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'carousel_widget.dart';
import 'home_page_variables.dart';
import 'info_widget.dart';
import '../../color_manager.dart';
import '../../widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),

          const InfoWidget(),

          const SizedBox(height: 20),

          const CarouselWidget(),

          const SizedBox(height: 20),

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
            items: HomePageVariables.bestSellerProducts
                .map((product) => ProductCard(product: product))
                .toList(),
            options: CarouselOptions(
              aspectRatio: 1.4,
              viewportFraction: 0.45,
              enlargeCenterPage: true,
              enlargeFactor: 0.2,
            ),
          ),

          const Text(
            'Footer',
            style: TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
