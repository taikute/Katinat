import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:katinat/pages/order_folder/order_detail_page.dart';
import 'package:katinat/services/color_manager.dart';
import 'package:katinat/services/currency_convert.dart';
import 'package:katinat/services/login_helper.dart';
import 'package:katinat/services/prefs_helper.dart';
import 'package:katinat/widgets/center_loading.dart';
import 'package:katinat/widgets/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/product_detail_model.dart';
import '../../services/location_helper.dart';

class OrderConfirmPage extends StatefulWidget {
  final List<ProductDetailModel> details;
  const OrderConfirmPage(this.details, {super.key});

  @override
  State<OrderConfirmPage> createState() => _OrderConfirmPageState();
}

class _OrderConfirmPageState extends State<OrderConfirmPage> {
  bool orderProcessing = false;
  List<ProductDetailModel> get details => widget.details;
  int get tempPrice {
    int price = 0;
    for (final detail in details) {
      price += detail.totalPrice;
    }
    return price;
  }

  int get totalQuantity => details
      .map((e) => e.quantity)
      .fold(0, (previousValue, element) => previousValue += element);
  final addressDetailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ORDER CONFIRM'),
      ),
      body: FutureBuilder(
        future: Geolocator.isLocationServiceEnabled(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CenterLoading();
          }
          final enabled = snapshot.data!;
          if (!enabled) {
            return const Text('Location services are disabled');
          }
          return FutureBuilder(
            future: Future<LocationPermission>(
              () async {
                var permission = await Geolocator.checkPermission();
                if (permission == LocationPermission.denied) {
                  permission = await Geolocator.requestPermission();
                }
                return permission;
              },
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CenterLoading();
              }
              final permission = snapshot.data!;
              if (permission == LocationPermission.denied) {
                return reloadButton(
                    'Location permissions are denied, hit reload and allow access!');
              }
              if (permission == LocationPermission.deniedForever) {
                return reloadButton(
                    'Location permissions are permanently denied, go to app setting and enable it!');
              }
              return FutureBuilder(
                future: Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.best,
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CenterLoading();
                  }
                  final location = snapshot.data!;
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          const DefaultTitle('Delivery address'),
                          FutureBuilder(
                            future: LocationHelper.getLocationName(location),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Text('Loading...');
                              }
                              String locationName = snapshot.data!;
                              return Text(locationName);
                            },
                          ),
                          //const Text('Address placeholder'),
                          const SizedBox(height: 10),
                          TextField(
                            controller: addressDetailController,
                            decoration: const InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Address detail',
                              hintText: 'Ex: 828 Su Van Hanh street',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Builder(builder: (context) {
                            String data;
                            if (totalQuantity > 1) {
                              data = 'Order summary ($totalQuantity products)';
                            } else {
                              data = 'Order summary ($totalQuantity product)';
                            }
                            return DefaultTitle(data);
                          }),
                          const SizedBox(height: 5),
                          detailList(),
                          const DefaultTitle('Payment method'),
                          Row(
                            children: [
                              Radio(
                                value: null,
                                groupValue: null,
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                              const Text('Cash on delivery'),
                            ],
                          ),
                          const SizedBox(height: 5),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Temporarily calculated:'),
                              Text(CurrencyConvert.toVND(tempPrice)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Shipping fee:'),
                              Text('20.000 VND'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const DefaultTitle('Total:'),
                              DefaultTitle(
                                CurrencyConvert.toVND(tempPrice + 20000),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: Visibility(
        visible: !orderProcessing,
        replacement: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: ColorManager.secondaryColor,
              borderRadius: BorderRadius.circular(25),
            ),
            width: double.infinity,
            height: 50,
            child: const FittedBox(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CenterLoading(),
              ),
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () async {
            setState(() {
              orderProcessing = true;
            });
            final user = await LoginHelper.curUser;
            if (user == null) {
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      title: Text('Alert'),
                      content: Text('Need login'),
                    );
                  },
                );
              }
            } else {
              final orderRef = FirebaseDatabase.instance
                  .ref('users/${user.phoneNumber}/orders');

              final orderSnapshot = await orderRef.get();
              final orderKey = orderSnapshot.children.length;
              final curOrderRef = orderRef.child('$orderKey');
              final detailRef = curOrderRef.child('details');

              await curOrderRef.child('price').set(tempPrice + 20000);
              await detailRef.set(details.map((detail) {
                return {
                  'key': detail.product.key,
                  'note': detail.noteString,
                };
              }).toList());
            }
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove(PrefsHelper.details);
            setState(() {
              orderProcessing = false;
            });
            if (!context.mounted) return;
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const OrderDetailPage();
              },
            ));
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                color: ColorManager.secondaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
              width: double.infinity,
              height: 50,
              child: const FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Order',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column detailList() {
    return Column(
      children: details.map(
        (detail) {
          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.grey[200],
                  height: 100,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        height: double.infinity,
                        child: Image.network(
                          detail.product.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detail.product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    detail.noteString,
                                    style: const TextStyle(
                                      height: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(detail.totalPriceVND),
                                  Text(
                                    'x ${detail.quantity}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ).toList(),
    );
  }

  Widget reloadButton(String msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(
              text: 'Reload',
              onTap: () => setState(() {}),
            ),
            Text(msg),
          ],
        ),
      ),
    );
  }
}

class DefaultTitle extends StatelessWidget {
  final String text;
  const DefaultTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: ColorManager.primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        height: 1,
      ),
    );
  }
}
