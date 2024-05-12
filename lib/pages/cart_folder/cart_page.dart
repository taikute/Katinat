import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import '../../data/read_data.dart';
import 'order_confirm_page.dart';
import '../../services/color_manager.dart';
import '../../services/snack_bar_helper.dart';
import '../../widgets/product_detail.dart';

import '../../models/product_detail_model.dart';
import '../../widgets/center_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/currency_convert.dart';
import '../../services/prefs_helper.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ReadData.fetchProductFromPrefs(),
      builder: (context, snapshot) {
        int totalPrice = 0;
        return Scaffold(
          appBar: AppBar(
            title: const Text('CART'),
          ),
          body: Builder(builder: (context) {
            if (!snapshot.hasData) {
              return const CenterLoading();
            }
            final details = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 10,
                    ),
                    child: Container(
                      height: 30,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorManager.primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Builder(builder: (context) {
                          String data;
                          if (details.isEmpty) {
                            data = 'Empty cart';
                          } else {
                            int total = 0;
                            for (final detailItem in details) {
                              total += detailItem.quantity;
                            }
                            data = 'You have $total product';
                            if (total > 1) data += 's';
                          }
                          return Text(
                            data,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Visibility(
                      visible: details.isNotEmpty,
                      replacement: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: Image.asset('assets/images/empty_cart.png'),
                      ),
                      child: ListView.separated(
                        itemCount: details.length,
                        itemBuilder: (context, index) {
                          return SwipeActionCell(
                            key: ObjectKey(details[index]),
                            trailingActions: [
                              SwipeAction(
                                color: Colors.transparent,
                                performsFirstActionWithFullSwipe: true,
                                onTap: (handler) async {
                                  await removeDetail(details, index);
                                  setState(() {});
                                },
                                content: const Expanded(
                                  child: Center(
                                    child: Icon(
                                      Icons.delete,
                                      size: 30,
                                      color: ColorManager.secondaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ProductDetail(
                                        details[index],
                                        index: index,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: DetailCard(detail: details[index]),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          bottomNavigationBar: Builder(builder: (context) {
            final details = snapshot.data;
            if (details != null) {
              for (final detail in details) {
                int price = detail.product.price;
                for (final topping in detail.toppings) {
                  price += topping.price;
                }
                totalPrice += price * detail.quantity;
              }
            }
            return SizedBox(
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
                            CurrencyConvert.toVND(totalPrice),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1,
                              color: ColorManager.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (totalPrice == 0) {
                            SnackBarHelper.hideAndShowSimpleSnackBar(
                              context,
                              'Empty cart!',
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return OrderConfirmPage(details!);
                              },
                            ),
                          );

                          // final location = await Geolocator.getCurrentPosition(
                          //   desiredAccuracy: LocationAccuracy.high,
                          // );
                          // final locationName =
                          //     await LocationHelper.getLocationName(
                          //         location.latitude, location.longitude);
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ColorManager.secondaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'NEXT',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Future<void> removeDetail(List<ProductDetailModel> details, int index) async {
    final prefs = await SharedPreferences.getInstance();
    details.removeAt(index);
    await prefs.setString(PrefsHelper.details,
        jsonEncode(details.map((e) => e.toMap()).toList()));
  }
}

class DetailCard extends StatelessWidget {
  final ProductDetailModel detail;
  const DetailCard({
    super.key,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: Colors.black12,
        height: 150,
        width: double.infinity,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.network(
                detail.product.image,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.product.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.primaryColor,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: getNoteItems(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              CurrencyConvert.toVND(getPrice()),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                //height: 1,
                                color: ColorManager.primaryColor,
                              ),
                            ),
                            DefaultNote('Qty: ${detail.quantity}'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getNoteItems() {
    List<Widget> items = [];
    if (toppingDisplay() != null) {
      items.add(DefaultNote(toppingDisplay()!));
    }
    if (detail.sugarLevel.index != 0) {
      items.add(DefaultNote('Sugar: ${detail.sugarLevel.name}'));
    }
    if (detail.iceLevel.index != 0) {
      items.add(DefaultNote('Ice: ${detail.iceLevel.name}'));
    }
    if (detail.note != null) {
      items.add(DefaultNote('Note: ${detail.note!}'));
    }
    return items;
  }

  String? toppingDisplay() {
    if (detail.toppings.isEmpty) {
      return null;
    }
    String str = detail.toppings.map((e) => e.name).join(', ');
    return 'Topping: $str';
  }

  int getPrice() {
    int price = detail.product.price;
    for (final topping in detail.toppings) {
      price += topping.price;
    }
    return price * detail.quantity;
  }
}

class DefaultNote extends StatelessWidget {
  final String note;
  const DefaultNote(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      note,
      style: const TextStyle(
        height: 1,
      ),
    );
  }
}
