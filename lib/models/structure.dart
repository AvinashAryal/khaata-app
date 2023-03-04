
// Author: Diwas Adhikari
// Structures and classes to save user's info

class UserData{
  String? id ;
  final String name, number, email, hash ;

  UserData({ required this.id, required this.name, required this.number, required this.email, required this.hash}) ;

  // Convert tuple to JSON so that we can later push it to the cloud store
  Map<String, dynamic> toJSON() => {
    'id' : id, 'name' : name, 'number' : number, 'email': email, 'hash' : hash
  } ;

  // Read the JSON from the document in the cloud store and convert to an user object with the tuple data
  static UserData fromJSON(Map<String, dynamic> json) =>
      UserData(id: json['id'], name : json['name'], number : json['number'],
               email: json['email'], hash : json['hash']) ;

}