import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/theme/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AdvertSection extends StatefulWidget {
  const AdvertSection({super.key});

  @override
  State<AdvertSection> createState() => _AdvertSectionState();
}

class _AdvertSectionState extends State<AdvertSection> {
  final PageController pageController = PageController(viewportFraction: 0.7);
  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.zero,
          child: CarouselSlider(
            carouselController: _carouselController, // Attach the controller
            options: CarouselOptions( // Set the height of the carousel
              viewportFraction: 1, // Show part of the next item
              enableInfiniteScroll: true, // Allow infinite scrolling
              enlargeCenterPage: true, // Don't pad ends
              autoPlay: true, // Auto-advance items
              autoPlayInterval: Duration(seconds: 5), // Auto-advance interval
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index; // Track current index
                });
              },
            ),
            items: [
              // First image
              Container(
                margin: EdgeInsets.zero, // Add space between images
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero, // Curved borders
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.zero, // Match the border radius
                  child: Image.asset('assets/images/boss.png', fit: BoxFit.cover),
                ),
              ),

              // Second image
              Container(
                margin: EdgeInsets.zero, // Add space between images
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero, // Curved borders
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.zero, // Match the border radius
                  child: Image.asset('assets/images/ad1.png', fit: BoxFit.cover),
                ),
              ),

              // Third image
              Container(
                margin: EdgeInsets.zero, // Add space between images
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero, // Curved borders
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.zero, // Match the border radius
                  child: Image.asset('assets/images/boss.png', fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Dots indicator with custom design
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex, // Bind the activeIndex with current carousel index
          count: 3, // Number of items in the carousel
          effect: const ExpandingDotsEffect(
            dotHeight: 7,
            dotWidth: 14,
            spacing: 8,
            radius: 4,
            activeDotColor: primaryColor,
            dotColor: primaryLight,
          ),
        ),
      ],
    );
    // return Container(
    //   padding: EdgeInsets.zero,
    //   child: CarouselSlider(
    //     options: CarouselOptions(
    //       height: 190, // Set the height of the carousel
    //       enableInfiniteScroll: true, // Allow infinite scrolling
    //       enlargeCenterPage: true, // Enlarge the center item
    //       autoPlay: true, // Auto-advance items
    //       autoPlayInterval: Duration(seconds: 2),
    //       // Auto-advance interval
    //     ),
    //     items: [
    //       Image.asset('assets/images/boss.png'),
    //       Image.asset('assets/images/ad1.png'),
    //       Image.asset('assets/images/boss.png'),
    //
    //       // Add more items as needed
    //     ],
    //   ),
    //
    // );
  }
}
