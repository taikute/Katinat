// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:katinat/services/login_helper.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ORDERS'),
      ),
      body: FutureBuilder(
        future: Future<List<OrderDetailModel>>(() async {
          final user = await LoginHelper.curUser;
          if (user == null) {
            return [];
          }
          final orderRef =
              FirebaseDatabase.instance.ref('users/${user.phoneNumber}/orders');
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
              child: Text('Login to see orders'),
            );
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              final order = orders[index];
              return Column(
                children: [
                  Text('Order key: ${order.key}'),
                  Text('Price: ${order.price}'),
                  Column(
                    children: order.details.map((map) {
                      return Column(
                        children: [
                          Text('Product key: ${map['key']}'),
                          Text('Note: ${map['note']}'),
                        ],
                      );
                    }).toList(),
                  )
                ],
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10);
            },
            itemCount: orders.length,
          );
        },
      ),
    );
  }
}

Future<List<OrderDetailModel>> getOrders() async {
  return [];
}

class OrderDetailModel {
  String key;
  List<Map<String, String>> details; // <Key, Note>
  int price;
  OrderDetailModel({
    required this.key,
    required this.details,
    required this.price,
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
    );
  }
}
