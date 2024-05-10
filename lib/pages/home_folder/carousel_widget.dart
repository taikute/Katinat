import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../data/read_data.dart';
import '../../widgets/center_loading.dart';

class CarouselWidget extends StatelessWidget {
  static List<Widget> items = [];
  const CarouselWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (buildContext, snapshot) {
        if (items.isEmpty) {
          return const CarouselPlaceholder();
        }
        return CarouselSlider(
          items: items,
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 1,
          ),
        );
      },
    );
  }
}

class CarouselPlaceholder extends StatelessWidget {
  const CarouselPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [Container(color: Colors.black12, child: const CenterLoading())],
      options: CarouselOptions(
        viewportFraction: 1,
      ),
    );
  }
}

Future<void> fetchData() async {
  final items = CarouselWidget.items;
  if (items.isNotEmpty) {
    return;
  }
  final urls = await ReadData.fetchCarouselImages();
  for (final url in urls) {
    final fileInfo = await DefaultCacheManager().downloadFile(url);
    items.add(
      Image.file(
        fileInfo.file,
        fit: BoxFit.cover,
      ),
    );
  }
}
