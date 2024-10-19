import 'package:flutter/material.dart';
import 'package:hfbbank/screens/rao/customer_type_products.dart';
import 'package:hfbbank/screens/rao/id_details.dart';
import 'package:hfbbank/screens/rao/income.dart';
import 'package:hfbbank/screens/rao/next_of_kin.dart';
import 'package:hfbbank/screens/rao/reach.dart';

import '../bridge.dart';

class RAO extends StatefulWidget {
  const RAO({super.key});

  @override
  State<RAO> createState() => _RAOState();
}

class _RAOState extends State<RAO> {
  final PageController _pageController = PageController();
  int _currentPage = 0;





  @override
  void initState() {
    // _getPlatformVersion();
    // TODO: implement igetnitState
    super.initState();
  }


  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                Reach(),
                IdentificationDocuments(),
                NextOfKin(),
                Income(),
                TypeProducts(),
                Container(
                  color: Colors.red,
                  child: Center(
                    // child: Text('Platform Version: $platformVersion'),
                  ),
                ),
              ],
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
            ),
          ),
          // SizedBox(height: 16),
          // ElevatedButton(
          //   onPressed: _nextPage,
          //   child: Text('Next Page'),
          // ),
        ],
      ),
    );
  }
}
