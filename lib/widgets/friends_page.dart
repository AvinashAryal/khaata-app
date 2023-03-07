
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
    return const Scaffold(body: FriendsList());
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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() async {
      await getFriendDetails() ;
    });
  }

  // Backend utilities {Diwas - Don't mess with field names !}
  // I will first get all ids of friends for current user !
  Future<void> getFriendsFromID() async{
    String reqID = Authentication().currentUser?.uid as String ;
    await Userbase().getUserDetails("id", reqID).then((specified) {
      // Forget setState and I lost my shit - hahahaha !
      setState(() {
        friends = specified.friends ;
      });
    }) ;
  }

  // Now I will use the list to get details of friends - Sneaky MOVE - HAHAHA !
  Future<void> getFriendDetails() async{
    await getFriendsFromID() ;
    for(var i=0; i<friends.length; i++){
      await Userbase().getUserDetails("id", friends[i].toString()).then((specified) {
        // Forget setState and I lost my shit - hahahaha !
        setState(() {
          friendDetails.insert(i, specified.name) ;
        });
      }) ;
    }
  }

  @override Widget build(BuildContext context) {
    return friendDetails.isEmpty ? (friends.isEmpty ? Center(child: "Got no friends?\nAdd one right now using '+'".text.lg.make())
        : Center(child: CircularProgressIndicator()))
        : ListView.builder(
        itemCount: friendDetails.length,
        itemBuilder: ((context, index) {
          return ListTile(
            leading: const Icon(CupertinoIcons.person_crop_circle_fill),
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
