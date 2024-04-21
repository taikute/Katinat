import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../color_manager.dart';
import '../data/read_data.dart';
import '../models/product_model.dart';
import 'coupon_page.dart';
import '../widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: 70,
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'GOOD MORNING, KATIES!',
                            style: TextStyle(
                              color: ColorManager.secondaryColor,
                            ),
                          ),
                          Text('Nguyễn Anh Tài'),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CouponPage(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.discount_outlined,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.notifications_none,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          CarouselSlider(
            items: getCarouselItems(),
            options: CarouselOptions(
              viewportFraction: 1,
              autoPlay: true,
            ),
          ),
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
          FutureBuilder(
            future: ReadData().products(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<ProductModel> products = snapshot.data!;
                return CarouselSlider(
                  items: products
                      .map((product) => ProductCard(product: product))
                      .toList(),
                  options: CarouselOptions(
                    aspectRatio: 1.4,
                    viewportFraction: 0.45,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.2,
                  ),
                );
              } else {
                return Container();
              }
            },
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

Widget carouselImage(String url) {
  return Image.asset(
    url,
    fit: BoxFit.cover,
  );
}

List<Widget> getCarouselItems() {
  List<String> urls = [
    'assets/images/carousel1.jpg',
    'assets/images/carousel2.jpg',
    'assets/images/carousel3.jpg',
    'assets/images/carousel4.jpg',
    'assets/images/carousel5.jpg',
    'assets/images/carousel6.jpg',
  ];

  return urls
      .map(
        (url) => SizedBox(
          width: double.infinity,
          child: Image.asset(
            url,
            fit: BoxFit.cover,
          ),
        ),
      )
      .toList();
}
