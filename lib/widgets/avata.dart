import 'package:flutter/material.dart';
import '../services/color_manager.dart';
import 'center_loading.dart';

class Avata extends StatelessWidget {
  final String? url;
  const Avata({
    super.key,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: ClipOval(
        child: Builder(
          builder: (context) {
            if (url == null) {
              return Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
              );
            }
            return Image.network(
              url!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress != null) {
                  return CircularProgressIndicator(
                    value: loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!,
                    color: ColorManager.primaryColor,
                    backgroundColor: Colors.black12,
                    strokeWidth: 2,
                  );
                }
                return child;
              },
            );
          },
        ),
      ),
    );
  }
}

class AvataLoading extends StatelessWidget {
  const AvataLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 70,
      child: ClipOval(
        child: Container(
          color: Colors.black12,
          child: const CenterLoading(),
        ),
      ),
    );
  }
}
