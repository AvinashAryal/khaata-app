import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khaata_app/backend/friendsLoader.dart';
import 'package:khaata_app/models/structure.dart';
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
                  child: "Your Friends".text.lg.bold.color(Colors.white).make(),
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
                  child:
                      "Friend Requests".text.lg.bold.color(Colors.white).make(),
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
  List<UserData> friendDetails = [];
  String tempName = "";
  var frLoad = FriendLoader() ;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() async {
      await frLoad.getFriendDetails().then((value){
        if(mounted) {
          super.setState(() {
            friends = frLoad.fetchFriends ;
            friendDetails = frLoad.fetchFriendDetails ;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return friendDetails.isEmpty
        ? (friends.isEmpty
            ? Center(
                child: Column(
                          children: [
                                        FriendSearchBar(),
                                        SizedBox(height: 40),
                                       "Got no friends? Add one right now using '+'".text.lg.make()
                                    ]
                            )
                   )
        : Center(child: CircularProgressIndicator()))
        : ListView.builder(
            itemCount: friendDetails.length+1,
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
                  title: "${friendDetails[index-1].name}".text.make(),
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
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      CupertinoIcons.person_fill,
                      color: Colors.blue,
                      size: 20,
                    ).pOnly(right: 48, left: 30),
                    SizedBox(
                      child: "Request ${index + 1}".text.xl.bold.make(),
                      width: 100,
                    ),
                    ButtonBar(
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
