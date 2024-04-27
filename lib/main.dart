import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'color_manager.dart';
import 'pages/home_page/home_page.dart';
import 'pages/home_page/home_page_variables.dart';
import 'pages/login_page.dart';
import 'pages/order_page.dart';
import 'pages/profile_page.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

// Future<bool> isAccept() async {
//   var isAccept = true;
//   if (Platform.isAndroid) {
//     final info = await DeviceInfoPlugin().androidInfo;
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString('device_id', info.id);
//   }
//   return isAccept;
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  // Init variables
  await HomePageVariables.init();

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'MainFont',
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      routes: {
        '/login': (context) => const LoginPage(),
      },
      home: const MainWidget(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  bool isShowing = false;
  int _selectedIndex = 0;
  static const List<Widget> _pageOptions = [
    HomePage(),
    OrderPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('KATINAT'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          backgroundColor: ColorManager.primaryColor,
        ),
        body: _pageOptions.elementAt(_selectedIndex),
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
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: ColorManager.secondaryColor,
          unselectedItemColor: Colors.white,
          backgroundColor: ColorManager.primaryColor,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
