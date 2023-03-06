
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khaata_app/pages/friends_details_page.dart';
import 'package:velocity_x/velocity_x.dart';

// Backend utilities
import 'package:khaata_app/backend/userbaseUtility.dart' ;
import 'package:khaata_app/backend/authentication.dart' ;

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: FriendsList());
  }
}

class FriendsList extends StatefulWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  List<dynamic> friends = [] ;
  List<String> friendDetails = [] ;
  String tempName = "" ;

  void initState() {
    super.initState();
    getFriendDetails() ;
  }

  // Backend utilities {Diwas - Don't mess with field names !}
  // I will first get all ids of friends for current user !
  Future<void> getFriendsFromID () async{
    await Userbase().getUserDetails("id", Authentication().CurrentUser?.uid as String).then((specified) {
      // Forget setState and I lost my shit - hahahaha !
      setState(() {
        friends = specified.friends ;
      });
    }) ;
  }

  // Now I will use the list to get details of friends - Sneaky MOVE - HAHAHA !
  Future<void> getFriendDetails() async{
    await getFriendsFromID() ;
    print(friends.length) ;
    for(var i=0; i<friends.length; i++){
      await Userbase().getUserDetails("id", friends[i].toString()).then((specified) {
        // Forget setState and I lost my shit - hahahaha !
        print(i) ;
        print(specified.name) ;
        setState(() {
          friendDetails.insert(i, specified.name) ;
        });
      }) ;
    }
  }

  @override Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: friendDetails.length,
        itemBuilder: ((context, index) {
          return ListTile(
            leading: Icon(CupertinoIcons.person_crop_circle_fill),
            trailing: "Rs. 100".text.make(),
            title: "${friendDetails[index]}".text.make(),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FriendDetail(id: index)));
            },
          );
        }));
  }
}
