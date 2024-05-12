import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';
import '../../widgets/center_loading.dart';

import '../../data/read_data.dart';
import '../../widgets/product_card.dart';

class OrderPage extends StatefulWidget {
  static List<ProductCard> cards = [];
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool bestSellerFilter = false;
  String? categoryFilter;
  List<String> categories = [
    'Katmatcha',
    'Vietnamese Coffee',
    'Milk Tea',
    'Milky Fruit Mix',
    'Fruit Tea',
  ];

  bool check() {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Visibility(
                  visible: !bestSellerFilter,
                  replacement: SecondaryButton(
                    text: 'Best seller',
                    onTap: () {
                      setState(() {
                        bestSellerFilter = false;
                      });
                    },
                  ),
                  child: PrimaryButton(
                    text: 'Best seller',
                    onTap: () {
                      setState(() {
                        bestSellerFilter = true;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      bool visible = true;
                      if (categoryFilter != null) {
                        if (categoryFilter == categories[index]) {
                          visible = false;
                        }
                      }
                      return Visibility(
                        visible: visible,
                        replacement: SecondaryButton(
                          text: categories[index],
                          onTap: () {
                            setState(() {
                              if (categoryFilter == categories[index]) {
                                categoryFilter = null;
                              } else {
                                categoryFilter = categories[index];
                              }
                            });
                          },
                        ),
                        child: PrimaryButton(
                          text: categories[index],
                          onTap: () {
                            setState(() {
                              if (categoryFilter == categories[index]) {
                                categoryFilter = null;
                              } else {
                                categoryFilter = categories[index];
                              }
                            });
                          },
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 10);
                    },
                    itemCount: categories.length,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (OrderPage.cards.isNotEmpty) {
                  var cards = OrderPage.cards;
                  if (bestSellerFilter) {
                    cards = cards
                        .where((e) => e.product.bestSeller == true)
                        .toList();
                  }
                  if (categoryFilter != null) {
                    cards = cards
                        .where((element) =>
                            element.product.category == categoryFilter!)
                        .toList();
                  }
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
          ),
        ),
      ],
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
