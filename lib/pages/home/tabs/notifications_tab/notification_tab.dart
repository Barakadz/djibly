import 'package:flutter/material.dart';

class NotificationTab extends StatefulWidget {

  static const String Tag = 'notifications_tab';

  const NotificationTab({Key key}) : super(key: key);

  @override
  State<NotificationTab> createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Notification"),
      ),
    );
  }
}
