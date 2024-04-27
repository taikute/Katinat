import 'package:flutter/material.dart';
import '../../color_manager.dart';
import '../coupon_page.dart';

class InfoWidget extends StatefulWidget {
  const InfoWidget({super.key});

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  String greeting = 'HELLO THERE';
  String name = 'Guest';
  String avata_url = 'assets/images/logo.png';
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      final currentHour = DateTime.now().hour;
      if (currentHour < 12) {
        greeting = 'GOOD MORNING';
      } else if (currentHour < 20) {
        greeting = 'GOOD EVENING';
      } else {
        greeting = 'GOOD NIGHT';
      }

      name = 'Nguyễn Anh Tài';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          SizedBox(
            height: 70,
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    avata_url,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '$greeting, KATIES!',
                          style: const TextStyle(
                            color: ColorManager.secondaryColor,
                          ),
                        ),
                        Text(name),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CouponPage(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.discount_outlined,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.notifications_none,
                  size: 30,
                ),
              ],
            ),
          ),
          Visibility(
            visible: !isLogin,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorManager.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: Text(
                          'Login/Register',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
