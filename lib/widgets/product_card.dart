import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:flutter/material.dart';
import '../services/color_manager.dart';
import '../services/currency_convert.dart';

import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
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
                  child: CachedNetworkImageBuilder(
                    url: product.image,
                    builder: (image) {
                      return Image.file(
                        image,
                        fit: BoxFit.cover,
                      );
                    },
                  )),
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
    );
  }
}
