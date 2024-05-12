import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/cart_folder/cart_page.dart';

import 'firebase_options.dart';
import 'pages/account_folder/account_page.dart';
import 'pages/home_folder/home_page.dart';
import 'pages/login_folder/login_page.dart';
import 'pages/order_folder/order_page.dart';
import 'services/color_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: ColorManager.primaryColor,
      statusBarColor: ColorManager.primaryColor,
    ),
  );

  // Only testing
  // final prefs = await SharedPreferences.getInstance();
  // prefs.remove(PrefsHelper.details);

  runApp(
    MaterialApp(
      color: ColorManager.primaryColor,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'MainFont',
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          color: ColorManager.primaryColor,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: ColorManager.primaryColor,
          selectedItemColor: ColorManager.secondaryColor,
          unselectedItemColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(
            color: ColorManager.primaryColor,
          ),
          floatingLabelStyle: const TextStyle(
            color: ColorManager.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(
              color: ColorManager.primaryColor,
              width: 2,
            ),
          ),
        ),
        // switchTheme: const SwitchThemeData(
        //   thumbColor: MaterialStatePropertyAll(ColorManager.primaryColor),
        //   trackColor: MaterialStatePropertyAll(ColorManager.secondaryColor),
        //   trackOutlineColor: MaterialStatePropertyAll(Colors.white),
        // ),
        buttonTheme: const ButtonThemeData(
          buttonColor: ColorManager.secondaryColor,
        ),
      ),
      routes: {
        '/home': (context) => const MainWidget(),
        '/order': (context) => const MainWidget(index: 1),
        '/account': (context) => const MainWidget(index: 2),
        '/login': (context) => const LoginPage(),
        '/cart': (context) => const CartPage(),
      },
      home: const MainWidget(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MainWidget extends StatefulWidget {
  final int? index;
  const MainWidget({
    super.key,
    this.index,
  });

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int selectedIndex = 0;
  bool isSwitched = false;

  static const List<Widget> _pageOptions = [
    HomePage(),
    OrderPage(),
    AccountPage(),
  ];

  @override
  void initState() {
    if (widget.index != null) {
      selectedIndex = widget.index!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KATINAT'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/cart');
            },
            child: const Icon(Icons.shopping_cart),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: _pageOptions.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Account',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
