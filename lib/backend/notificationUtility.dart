
// Author: Diwas Adhikari
// Firebase Access and CRUD Stuff - TransactionRecord Utility

import "package:cloud_firestore/cloud_firestore.dart" ;
import 'package:khaata_app/backend/authentication.dart';
import '../models/notification.dart';

class Notifier {
  final _database = FirebaseFirestore.instance;

  String collectionPath = "notifications"; // Don't mess with this as well - HAHAHA !
  final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  // Create a new transaction and store it in the cloud (C)
  createNewNotification(Notify notify) async {
    await _database.collection(collectionPath).add(notify.toJSON())
        .whenComplete(() {
      // do smth
    })
        .catchError((error) {
      print("Error: + $error");
    });
  }

  Future<List<Notify>> getAllNotifications() async {
    if (Authentication().currentUser?.uid == null) {
      return [];
    }
    String reqID = Authentication().currentUser?.uid as String;
    final snapShot = await _database.collection(collectionPath).where("toID", isEqualTo: reqID)
        .orderBy("time", descending: true).get();
    final data = snapShot.docs.map((e) => Notify.fromSnapshot(e)).toList();
    return data;
  }
}
