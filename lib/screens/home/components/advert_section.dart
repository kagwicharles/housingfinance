import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

class AdvertSection extends StatefulWidget {
  const AdvertSection({super.key});

  @override
  State<AdvertSection> createState() => _AdvertSectionState();
}

class _AdvertSectionState extends State<AdvertSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200, // Set the height of the carousel
          enableInfiniteScroll: true, // Allow infinite scrolling
          enlargeCenterPage: true, // Enlarge the center item
          autoPlay: true, // Auto-advance items
          autoPlayInterval: Duration(seconds: 2),
          // Auto-advance interval
        ),
        items: [
          Image.asset('assets/images/boss.png'),
          Image.asset('assets/images/ad1.png'),
          Image.asset('assets/images/boss.png'),

          // Add more items as needed
        ],
      ),

    );
  }
}
