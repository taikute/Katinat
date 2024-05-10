import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:katinat/models/product_detail_model.dart';

import '../models/product_model.dart';
import '../services/color_manager.dart';
import '../services/currency_convert.dart';
import 'product_detail.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final File imageFile;
  const ProductCard(
      {super.key, required this.product, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ProductDetail(ProductDetailModel(product, toppings: []));
              },
            ),
          );
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                  width: double.infinity,
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, top: 2, right: 4),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                height: 1,
                                fontSize: constraints.maxHeight / 4,
                                color: ColorManager.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  CurrencyConvert.toVND(product.price),
                                  style: TextStyle(
                                    height: 1,
                                    fontSize: constraints.maxHeight / 4,
                                    color: ColorManager.primaryColor,
                                  ),
                                ),
                                const Icon(
                                  Icons.add_circle_outline_outlined,
                                  color: ColorManager.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
