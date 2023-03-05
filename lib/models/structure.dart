
// Author: Diwas Adhikari
// Structures and classes to save user's info

import 'package:cloud_firestore/cloud_firestore.dart';

class UserData{
  String? id ;
  final String name, number, email, hash ;

  UserData({ required this.id, required this.name, required this.number, required this.email, required this.hash}) ;

  // Convert tuple to JSON so that we can later push it to the cloud store
  Map<String, dynamic> toJSON() => {
    'id' : id, 'name' : name, 'number' : number, 'email': email, 'hash' : hash
  } ;

  // Read the JSON from the document in the cloud store and convert to an user object with the tuple data
  // (Two methods to do sa,me - hahhahaha) !
  static UserData fromJSON(Map<String, dynamic> json) =>
      UserData(id: json['id'], name : json['name'], number : json['number'],
               email: json['email'], hash : json['hash']) ;

  factory UserData.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> docu){
        final data = docu.data()! ;
        return UserData(id: docu.id, name: data["name"], number: data["number"], email: data["email"], hash: data["hash"]) ;
  }











}