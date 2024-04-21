import 'package:flutter/material.dart';

class CouponPage extends StatelessWidget {
  const CouponPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your coupon'),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SearchBar(
          leading: Icon(Icons.search),
          hintText: 'Input code',
          hintStyle: MaterialStatePropertyAll(
            TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
