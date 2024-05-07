import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:katinat/services/init_data.dart';

import '../../widgets/product_card.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: GridView.count(
        childAspectRatio: 3 / 5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        crossAxisCount: 2,
        children: getItems(),
      ),
    );
  }
}

List<Widget> getItems() {
  return InitData.products!
      .map((product) => ProductCard(product: product))
      .toList();
}
