// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:katinat/services/color_manager.dart';

import 'package:katinat/services/currency_convert.dart';
import 'package:katinat/services/login_helper.dart';
import 'package:katinat/widgets/center_loading.dart';

import '../../models/product_model.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  int? expandedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ORDER HISTORY'),
      ),
      body: FutureBuilder(
        future: LoginHelper.curUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CenterLoading();
          }
          if (snapshot.data == null) {
            return const Center(
              child: Text('Login to continues!'),
            );
          }
          final user = snapshot.data!;
          return FutureBuilder(
            future: Future<List<OrderDetailModel>>(() async {
              final orderRef = FirebaseDatabase.instance
                  .ref('users/${user.phoneNumber}/orders');
              final orderSnapshot = await orderRef.get();
              final orders = (orderSnapshot.children)
                  .map((snapshot) => OrderDetailModel.fromSnapshot(snapshot))
                  .toList();
              return orders;
            }),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              final orders = snapshot.data!;
              if (orders.isEmpty) {
                return const Center(
                  child: Text('Empty order!'),
                );
              }
              return ListViewOrders(orders: orders);
            },
          );
        },
      ),
    );
  }
}

class ListViewOrders extends StatefulWidget {
  final List<OrderDetailModel> orders;
  const ListViewOrders({
    super.key,
    required this.orders,
  });

  @override
  State<ListViewOrders> createState() => _ListViewOrdersState();
}

class _ListViewOrdersState extends State<ListViewOrders> {
  int? expandedIndex;
  List<OrderDetailModel> get orders => widget.orders;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.separated(
        itemBuilder: (context, index) {
          final order = orders[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                if (expandedIndex != null && expandedIndex == index) {
                  expandedIndex = null;
                } else {
                  expandedIndex = index;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Builder(
                builder: (context) {
                  if (expandedIndex != null && expandedIndex == index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Detail of order',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: ColorManager.primaryColor,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: order.details.map((detail) {
                            return FutureBuilder(
                              future: Future<ProductModel>(() async {
                                final productSnapShot = await FirebaseDatabase
                                    .instance
                                    .ref('products/${detail['key']}')
                                    .get();
                                return ProductModel.fromSnapShot(
                                    productSnapShot);
                              }),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Text('Loading...');
                                }
                                final product = snapshot.data!;
                                final note = detail['note'];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Product name: ${product.name}',
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Visibility(
                                      visible: note != null && note.isNotEmpty,
                                      child: Text(note ?? ''),
                                    ),
                                  ],
                                );
                              },
                            );
                          }).toList(),
                        ),
                        Text(
                          'Total price: ${order.price}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Create time: ${order.createTime}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order.createTime.toString()),
                      Text(CurrencyConvert.toVND(order.price)),
                    ],
                  );
                },
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
        itemCount: orders.length,
      ),
    );
  }
}

class OrderDetailCard extends StatelessWidget {
  final OrderDetailModel model;
  const OrderDetailCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Future<List<OrderDetailModel>> getOrders() async {
  return [];
}

class OrderDetailModel {
  String key;
  String address;
  List<Map<String, String>> details; // key = [key, note]
  int price;
  DateTime createTime;

  OrderDetailModel({
    required this.key,
    required this.address,
    required this.details,
    required this.price,
    required this.createTime,
  });

  factory OrderDetailModel.fromSnapshot(DataSnapshot snapshot) {
    final map = snapshot.value as Map;
    final details = map['details'] as List;
    return OrderDetailModel(
      key: snapshot.key!,
      details: details
          .map((detail) => <String, String>{
                'key': detail['key'],
                'note': detail['note'],
              })
          .toList(),
      price: map['price'],
      address: map['address'],
      createTime: DateTime.parse(map['create_time']),
    );
  }
}
