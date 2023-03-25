import 'package:flutter/material.dart';
import 'package:khaata_app/models/notification.dart';
import 'package:velocity_x/velocity_x.dart';

import '../backend/notificationUtility.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Notify> notifications = [];
  var notifier = Notifier();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await notifier.getAllNotifications().then((value) {
        if (mounted) {
          super.setState(() {
            notifications = value;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Notifications".text.make(),
        actions: [
          IconButton(
              onPressed: (() {
                //insert code to clear all notifications here
              }),
              icon: Icon(Icons.clear_all)),
        ],
      ),
      body: notifications.isEmpty
          ? "No new notifications !".text.lg.bold.makeCentered()
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: ((context, index) {
                return Card(
                  child: ListTile(
                      title: "${notifications[index].message}".text.make(),
                      leading:
                          "${Notifier().days[notifications[index].time.toDate().weekday]}-"
                                  "${Notifier().months[notifications[index].time.toDate().month]} ${notifications[index].time.toDate().day}"
                              .text
                              .sm
                              .make(),
                      trailing:
                          "${notifications[index].time.toDate().toString().substring(10, 16)}"
                              .text
                              .sm
                              .make()),
                );
              })),
    );
  }
}
