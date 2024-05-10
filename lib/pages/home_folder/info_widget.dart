import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../widgets/avata.dart';

import '../../services/color_manager.dart';
import '../../services/login_helper.dart';
import '../../widgets/primary_button.dart';

class InfoWidget extends StatefulWidget {
  static UserModel? user;
  const InfoWidget({super.key});

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  late String greeting;
  String name = '';
  bool isLogin = true;

  @override
  void initState() {
    super.initState();
    final currentHour = DateTime.now().hour;
    if (currentHour < 12) {
      greeting = 'GOOD MORNING';
    } else if (currentHour < 18) {
      greeting = 'GOOD EVENING';
    } else {
      greeting = 'GOOD NIGHT';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: updateUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return InfoBuild(
            greeting: greeting,
            user: InfoWidget.user,
          );
        }
        return InfoBuild(
          greeting: greeting,
          loading: true,
        );
      },
    );
  }
}

Future<void> updateUser() async {
  InfoWidget.user = await LoginHelper.curUser;
}

class InfoBuild extends StatelessWidget {
  final String greeting;
  final bool loading;
  final UserModel? user;

  const InfoBuild({
    super.key,
    this.loading = false,
    this.user,
    required this.greeting,
  });

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
                Visibility(
                  visible: !loading,
                  replacement: const AvataLoading(),
                  child: Avata(
                    url: user?.avataUrl,
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
                        Builder(
                          builder: (context) {
                            if (loading) {
                              return const Text('Loading...');
                            }
                            if (user == null) {
                              return const Text('Guest');
                            }
                            return Text(user!.name);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Icon(Icons.discount_outlined, size: 30),
                const SizedBox(width: 5),
                const Icon(Icons.notifications_none, size: 30),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: user == null && loading == false,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const PrimaryButton(text: 'Login/Sign up'),
            ),
          ),
        ],
      ),
    );
  }
}
