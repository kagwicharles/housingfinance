import 'package:flutter/material.dart';

class NotificationsClass extends StatefulWidget {
  const NotificationsClass({super.key});

  @override
  State<NotificationsClass> createState() => _NotificationsClassState();
}

class _NotificationsClassState extends State<NotificationsClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications'),),
      body: Center(
        child: Text('You have no notifications at the moment'),
      ),
    );
  }
}
