
// Author: Diwas Adhikari
// Structures and classes to save user's info

class User{
  String id ;
  final String name, number, hash ;

  User({ this.id = '', required this.name, required this.number, required this.hash}) ;

  // Convert tuple to JSON so that we can later push it to the cloud store
  Map<String, dynamic> toJSON() => {
    'id' : id, 'name' : name, 'number' : number, 'hash' : hash
  } ;

  // Read the JSON from the document in the cloud store and convert to an user object with the tuple data
  static User fromJSON(Map<String, dynamic> json) =>
      User(id: json['id'], name : json['name'], number : json['number'], hash : json['hash']) ;
}