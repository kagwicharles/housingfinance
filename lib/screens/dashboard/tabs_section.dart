import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';

class TabSection extends StatefulWidget {
  const TabSection({super.key});

  @override
  State<TabSection> createState() => _TabSectionState();
}

class _TabSectionState extends State<TabSection> {
  List<Widget> tabs = [
    const Tab(child: Text("Trending")),
    const Tab(child: Text("Promotions")),
    const Tab(child: Text("Summer Offer")),
    const Tab(child: Text("News"))
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ButtonsTabBar(
            backgroundColor: const Color(0xffF6B700),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            height: 58,
            labelStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
            // Add your tabs here
            tabs: tabs,
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
              width: double.infinity,
              height: 200,
              child: const TabBarView(
                children: [
                  Text("Trending"),
                  Text("Promotions"),
                  Text("Summer offer"),
                  Text("News")
                ],
              ))
        ]);
  }
}
