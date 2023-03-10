
// Author: Diwas Adhikari
// Firebase Access and CRUD Stuff - Userbase Utility

import "package:cloud_firestore/cloud_firestore.dart" ;
import '../models/structure.dart';

class Userbase{
  final _database = FirebaseFirestore.instance ;
  String collectionPath = "user-data" ; // Don't mess with this as well - HAHAHA !

  // Create a new user and store it in the cloud (C)
  createNewUser(UserData user) async {
      await _database.collection(collectionPath).add(user.toJSON())
          .whenComplete((){
              // do smth
          })
          .catchError((error){
              print("Error: + $error") ;
          }) ;
  }

  // Get a list of users from the cloud whose certain field value is certain - HAHAHA ! (R)
  Future<UserData> getUserDetails(String fieldType, String value) async{
    final snapShot = await _database.collection(collectionPath).where(fieldType, isEqualTo: value).get() ;
    final data = snapShot.docs.map((e) => UserData.fromSnapshot(e)).single ;
    return data ;
  }

  // Get a bunch of user from the cloud that satisfy the where clause - HAHAHA ! (R)
  Future<List<UserData>> getBunchOfUsers(String fieldType, String value) async{
    final snapShot = await _database.collection(collectionPath).where(fieldType, isEqualTo: value).get() ;
    final data = snapShot.docs.map((e) => UserData.fromSnapshot(e)).toList() ;
    return data ;
  }

  // SAME RETREIVAL STUFF FOR ARRAYS
  // Get a specific user from the cloud stored in a list whose certain field value is certain - HAHAHA ! (R)
  Future<UserData> getUserDataWithinList(String fieldType, List<dynamic> values) async{
    final snapShot = await _database.collection(collectionPath).where(fieldType, arrayContains: values).get() ;
    final data = snapShot.docs.map((e) => UserData.fromSnapshot(e)).single ;
    return data ;
  }

  // Get a list of users from the cloud whose certain field value is certain - HAHAHA ! (R)
  Future<List<UserData>> getBunchOfUsersWithinList(String arrayType, List<dynamic> values) async{
    final snapShot = await _database.collection(collectionPath).where(arrayType, arrayContains: values).get() ;
    final data = snapShot.docs.map((e) => UserData.fromSnapshot(e)).toList() ;
    return data ;
  }

  // This is the best hack to create a somewhat LIKE query in Firestore. (Diwas - Its query system sucks !)
  Future<List<UserData>> getBunchOfUsersSimilar(String fieldType, String value) async{
    final snapShot = await _database.collection(collectionPath).orderBy(fieldType)
                                    .startAt(['$value']).endAt(['$value\uf8ff']).get() ;
    final data = snapShot.docs.map((e) => UserData.fromSnapshot(e)).toList() ;
    return data ;
  }

  Future<List<UserData>> getAllUserData() async{
    final snapShot = await _database.collection(collectionPath).get() ;
    final data = snapShot.docs.map((e) => UserData.fromSnapshot(e)).toList() ;
    return data ;
  }
}

