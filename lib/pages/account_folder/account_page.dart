import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:katinat/pages/order_folder/order_detail_page.dart';

import '../../services/login_helper.dart';
import '../../widgets/center_loading.dart';
import '../../widgets/primary_button.dart';
import 'profile_widget.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late StreamSubscription internetListener;
  bool isConnected = true;

  @override
  void initState() {
    internetListener = InternetConnection().onStatusChange.listen((event) {
      if (isConnected && event == InternetStatus.connected) {
        return;
      }
      setState(() {
        if (event == InternetStatus.connected) {
          isConnected = true;
        } else {
          isConnected = false;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    internetListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !isConnected,
      replacement: FutureBuilder(
        future: LoginHelper.curUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData) {
              return const LoginButton();
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  ProfileWidget(user: snapshot.data!),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        LoginHelper.logout();
                      });
                    },
                    child: const PrimaryButton(text: 'Logout'),
                  ),
                  const SizedBox(height: 10),
                  PrimaryButton(
                    text: 'Order history',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const OrderDetailPage();
                          },
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          } else {
            return const CenterLoading(text: 'Connecting...');
          }
        },
      ),
      child: const CenterLoading(text: 'Waiting for internet...'),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/login');
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: PrimaryButton(
            text: 'Login/Sign up',
          ),
        ),
      ),
    );
  }
}
