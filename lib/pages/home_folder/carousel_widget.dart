import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:katinat/services/init_data.dart';
import 'package:katinat/widgets/center_loading.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: InitData.carouselImages!.map((url) {
        return CachedNetworkImageBuilder(
          url: url,
          builder: (image) {
            return Image.file(
              image,
              fit: BoxFit.cover,
            );
          },
          placeHolder: const CenterLoading(),
        );
      }).toList(),
      options: CarouselOptions(
        viewportFraction: 1,
        autoPlay: true,
      ),
    );
  }
}
