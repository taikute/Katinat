import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:flutter/material.dart';
import 'package:katinat/widgets/center_loading.dart';

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
            return CachedNetworkImageBuilder(
              url: url!,
              builder: (image) {
                return Image.file(
                  image,
                  fit: BoxFit.cover,
                );
              },
              placeHolder: const AvataLoading(),
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
