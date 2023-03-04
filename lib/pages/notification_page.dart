import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Notifications".text.make(),
      ),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: ((context, index) {
            return ListTile(title: "Notification ${index + 1}".text.make());
          })),
    );
  }
}
