import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../widgets/center_loading.dart';

import '../../data/read_data.dart';
import '../../widgets/product_card.dart';

class OrderPage extends StatelessWidget {
  static List<ProductCard> cards = [];
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (cards.isNotEmpty) {
            return GridView.count(
              childAspectRatio: 3 / 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: 2,
              children: cards,
            );
          }
          return Container(
            color: Colors.black12,
            child: const CenterLoading(),
          );
        },
      ),
    );
  }
}

Future<void> fetchData() async {
  final cards = OrderPage.cards;
  if (cards.isNotEmpty) {
    return;
  }
  final products = await ReadData.fetchProducts();
  for (final product in products) {
    final fileInfo = await DefaultCacheManager().downloadFile(product.image);
    cards.add(ProductCard(product: product, imageFile: fileInfo.file));
  }
}
