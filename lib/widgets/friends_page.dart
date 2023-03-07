import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khaata_app/pages/friends_details_page.dart';
import 'package:khaata_app/widgets/add_new_friend_search_bar.dart';
import 'package:khaata_app/widgets/drawer.dart';
import 'package:khaata_app/widgets/friends_search_bar.dart';
import 'package:velocity_x/velocity_x.dart';

// Backend utilities
import 'package:khaata_app/backend/userbaseUtility.dart';
import 'package:khaata_app/backend/authentication.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: MyDrawer(),
          floatingActionButton: AddFriendSearchBar(),
          appBar: AppBar(
            title: "Friends".text.make(),
            bottom: TabBar(tabs: [
              Tab(
                icon: Container(
                  alignment: Alignment.center,
                  width: 450,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: "Your Friends".text.xl.color(Colors.white70).make(),
                ),
              ),
              Tab(
                icon: Container(
                  alignment: Alignment.center,
                  width: 450,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      borderRadius: BorderRadius.circular(20)),
                  child: "Friend Requests".text.xl.color(Colors.white70).make(),
                ),
              )
            ]),
          ),
          body: TabBarView(children: [FriendsList(), FriendRequestList()]),
        ));
  }
}

class FriendsList extends StatefulWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  List<dynamic> friends = [];
  List<String> friendDetails = [];
  String tempName = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await getFriendDetails();
    });
  }

  // Backend utilities {Diwas - Don't mess with field names !}
  // I will first get all ids of friends for current user !
  Future<void> getFriendsFromID() async {
    String reqID = Authentication().currentUser?.uid as String;
    await Userbase().getUserDetails("id", reqID).then((specified) {
      // Forget setState and I lost my shit - hahahaha !
      setState(() {
        friends = specified.friends;
      });
    });
  }

  // Now I will use the list to get details of friends - Sneaky MOVE - HAHAHA !
  Future<void> getFriendDetails() async {
    await getFriendsFromID();
    for (var i = 0; i < friends.length; i++) {
      await Userbase()
          .getUserDetails("id", friends[i].toString())
          .then((specified) {
        // Forget setState and I lost my shit - hahahaha !
        setState(() {
          friendDetails.insert(i, specified.name);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return friendDetails.isEmpty
        ? (friends.isEmpty
            ? Center(
                child: "Got no friends? Add one right now using '+'"
                    .text
                    .lg
                    .make())
            : Center(child: CircularProgressIndicator()))
        : ListView.builder(
            itemCount: friendDetails.length + 1,
            itemBuilder: ((context, index) {
              if (index == 0) {
                return FriendSearchBar();
              }
              return Card(
                child: ListTile(
                  leading: Icon(
                    CupertinoIcons.person_fill,
                    color: Colors.blue,
                  ),
                  trailing: "Rs. 100".text.make(),
                  title: "${friendDetails[index]}".text.make(),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FriendDetail(id: index)));
                  },
                ),
              );
            }));
  }
}

class FriendRequestList extends StatefulWidget {
  const FriendRequestList({super.key});

  @override
  State<FriendRequestList> createState() => _FriendRequestListState();
}

class _FriendRequestListState extends State<FriendRequestList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: ((context, index) {
          return Card(
              elevation: 5,
              child: Row(children: [
                Icon(
                  CupertinoIcons.person_fill,
                  color: Colors.blue,
                  size: 20,
                ).pOnly(right: 48, left: 30),
                SizedBox(
                  child: "Request ${index + 1}".text.xl.bold.make(),
                  width: 180,
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.check,
                          color: Colors.green,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                        ))
                  ],
                ),
              ]));
        }));
  }
}
