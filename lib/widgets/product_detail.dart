import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:katinat/data/read_data.dart';
import 'package:katinat/models/product_detail_model.dart';
import 'package:katinat/services/color_manager.dart';
import 'package:katinat/services/currency_convert.dart';
import 'package:katinat/services/prefs_helper.dart';
import 'package:katinat/services/snack_bar_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';

class ProductDetail extends StatefulWidget {
  final ProductDetailModel detail;
  final int? index;
  const ProductDetail(
    this.detail, {
    super.key,
    this.index,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool updating = false;
  final noteController = TextEditingController();
  ProductDetailModel get detail => widget.detail;
  ProductModel get product => widget.detail.product;
  int? get index => widget.index;
  bool get isEditing => index != null;
  int get price {
    int price = product.price;
    for (final topping in detail.toppings) {
      price += topping.price;
    }
    return price * detail.quantity;
  }

  @override
  void initState() {
    super.initState();
    if (detail.note != null) {
      noteController.text = detail.note!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product.image,
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 1.5,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.primaryColor,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.des ?? 'Null Description',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const DefaultDivider(),
            const DefaultLabel('Extra Topping'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: Topping.values.map((topping) {
                return Row(
                  children: [
                    Checkbox(
                      value: detail.toppings.contains(topping),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            detail.toppings.add(topping);
                          } else {
                            detail.toppings.remove(topping);
                          }
                        });
                      },
                    ),
                    Text(topping.name),
                    const Spacer(),
                    Text(CurrencyConvert.toVND(topping.price)),
                    const SizedBox(width: 10),
                  ],
                );
              }).toList(),
            ),
            const DefaultDivider(),
            const DefaultLabel('Sugar Level'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: SugarLevel.values.map((sugarLever) {
                return Row(
                  children: [
                    Radio(
                      value: sugarLever,
                      groupValue: detail.sugarLevel,
                      onChanged: (value) {
                        setState(() {
                          detail.sugarLevel = sugarLever;
                        });
                      },
                    ),
                    Text(sugarLever.name),
                  ],
                );
              }).toList(),
            ),
            const DefaultDivider(),
            const DefaultLabel('Ice Level'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: IceLevel.values.map((iceLevel) {
                return Row(
                  children: [
                    Radio(
                      value: iceLevel,
                      groupValue: detail.iceLevel,
                      onChanged: (value) {
                        setState(() {
                          detail.iceLevel = iceLevel;
                        });
                      },
                    ),
                    Text(iceLevel.name),
                  ],
                );
              }).toList(),
            ),
            const DefaultDivider(),
            const DefaultLabel('Note'),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  hintText: '...',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CurrencyConvert.toVND(price),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1,
                        color: ColorManager.primaryColor,
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (detail.quantity == 1) {
                                  return;
                                }
                                detail.quantity--;
                              });
                            },
                            child: const Icon(
                              Icons.remove_circle_outline_rounded,
                              color: ColorManager.primaryColor,
                              size: 25,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            child: Center(
                              child: Text(
                                '${detail.quantity}',
                                style: const TextStyle(
                                  color: ColorManager.primaryColor,
                                  fontSize: 18,
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (detail.quantity == 99) {
                                  return;
                                }
                                detail.quantity++;
                              });
                            },
                            child: const Icon(
                              Icons.add_circle_outline_rounded,
                              color: ColorManager.primaryColor,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    // Avoid user spam
                    if (updating) {
                      return;
                    }
                    setState(() {
                      updating = true;
                    });
                    bool isSuccess = await addToCartHandled();
                    if (!context.mounted) return;
                    String msg;
                    if (!isSuccess) {
                      msg = 'Error';
                      setState(() {
                        updating = false;
                      });
                    } else {
                      Navigator.pop(context);
                      if (isEditing) {
                        Navigator.pushReplacementNamed(context, '/cart');
                        msg = 'Update successful!';
                      } else {
                        msg = 'Add Successful!';
                      }
                    }
                    SnackBarHelper.hideAndShowSimpleSnackBar(context, msg);
                  },
                  child: AddToCartButton(
                    isEditing: isEditing,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> addToCartHandled() async {
    detail.note = noteController.text.isEmpty ? null : noteController.text;
    final prefs = await SharedPreferences.getInstance();
    final details = await ReadData.fetchProductFromPrefs();
    if (details.isEmpty) {
      return await prefs.setString(
          PrefsHelper.details, jsonEncode([detail.toMap()]));
    }

    if (isEditing) {
      bool isContains = false;
      for (final detailItem in details) {
        if (detailItem.like(detail) && details.indexOf(detailItem) != index!) {
          detailItem.quantity += detail.quantity;
          details.removeAt(index!);
          isContains = true;
          break;
        }
      }
      if (!isContains) {
        details[index!] = detail;
      }
    } else {
      bool isContains = false;
      for (final detailItem in details) {
        if (detailItem.like(detail)) {
          detailItem.quantity += detail.quantity;
          isContains = true;
          break;
        }
      }
      if (!isContains) {
        details.add(detail);
      }
    }
    return await prefs.setString(PrefsHelper.details,
        jsonEncode(details.map((e) => e.toMap()).toList()));
  }
}

class AddToCartButton extends StatelessWidget {
  final bool isEditing;
  const AddToCartButton({
    super.key,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorManager.secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          !isEditing ? 'ADD TO CART' : 'UPDATE',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class DefaultDivider extends StatelessWidget {
  const DefaultDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        color: Colors.grey[300],
        thickness: 10,
      ),
    );
  }
}

class DefaultLabel extends StatelessWidget {
  final String label;
  const DefaultLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          height: 1,
          color: ColorManager.primaryColor,
        ),
      ),
    );
  }
}

class DefaultBody extends StatelessWidget {
  final String content;
  const DefaultBody(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 18,
        height: 1,
        color: ColorManager.primaryColor,
      ),
    );
  }
}
