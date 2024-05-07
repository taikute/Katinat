import 'package:flutter/material.dart';

import 'best_seller_widget.dart';
import 'carousel_widget.dart';
import 'info_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          InfoWidget(),
          SizedBox(height: 10),
          CarouselWidget(),
          SizedBox(height: 10),
          BestSellerWidget(),
          Text(
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
