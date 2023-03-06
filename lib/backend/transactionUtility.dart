
// Author: Diwas Adhikari
// Firebase Access and CRUD Stuff - TransactionRecord Utility

import "package:cloud_firestore/cloud_firestore.dart" ;
import 'package:flutter/material.dart';
import 'package:khaata_app/backend/authentication.dart';
import '../models/transaction.dart';

class TransactionRecord{
  final _database = FirebaseFirestore.instance ;
  String collectionPath = "transaction-data" ; // Don't mess with this as well - HAHAHA !
  final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'] ;
  final months = ['Jan', 'Feb', 'Mar', 'May', 'Apr', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'] ;

  // Create a new transaction and store it in the cloud (C)
  createNewRecord(Record transaction) async {
    await _database.collection(collectionPath).add(transaction.toJSON())
        .whenComplete((){
      // do smth
    })
        .catchError((error){
      print("Error: + $error") ;
    }) ;
  }

  // Get a list of transaction from the cloud whose certain field value is certain - HAHAHA ! (R)
  Future<Record> getRecordDetails(String fieldType, String value) async{
    final snapShot = await _database.collection(collectionPath).where(fieldType, isEqualTo: value).get() ;
    final data = snapShot.docs.map((e) => Record.fromSnapshot(e)).single ;
    return data ;
  }

  // Get 5 recent records until today (R)
  // Very sensitive function because it has built composite index in Firestore - {WARNING {Diwas} - Don't touch this guy - HAHAHA}
  Future<List<Record>> getRecentRecords(int limiter) async{
    String reqID = await Authentication().CurrentUser?.uid as String ;
    final snapShot = await _database.collection(collectionPath)
                           //.where("lenderID == ${reqID} || borrowerID == ${reqID}")
                           .where("lenderID", isEqualTo: Authentication().CurrentUser?.uid as String)
                           .where("transactionDate", isLessThanOrEqualTo: Timestamp.now())
                           .limit(limiter).orderBy("transactionDate", descending: true).get() ;
    final data = snapShot.docs.map((e) => Record.fromSnapshot(e)).toList() ;
    return data ;
  }
}


