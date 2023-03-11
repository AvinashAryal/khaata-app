// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:khaata_app/models/structure.dart';

import '../backend/friendsLoader.dart';
import '../backend/userbaseUtility.dart';

List<UserData> users = [];

class AddFriendSearchBar extends StatefulWidget {
  const AddFriendSearchBar({super.key});

  @override
  State<AddFriendSearchBar> createState() => _AddFriendSearchBarState();
}

class _AddFriendSearchBarState extends State<AddFriendSearchBar> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await Userbase().getAllUserData().then((value) {
        if (mounted) {
          super.setState(() {
            users = value;
          });
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          showSearch(context: context, delegate: CustomSearchDelegate());
        },
        child: const Icon(CupertinoIcons.person_add));
  }
}

class CustomSearchDelegate extends SearchDelegate {
  // Back-end data fetch {Diwas - "Yeah this is how we do it !"}
  List<UserData> matchedQuery = [];
  var frLoad = FriendLoader();

  @override
  List<Widget>? buildActions(BuildContext context) {
    //clear query
    return [
      IconButton(
          onPressed: (() {
            matchedQuery = [];
            query = "";
          }),
          icon: Icon(CupertinoIcons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: (() {
          //closes the search bar
          matchedQuery = [];
          close(context, null);
        }),
        icon: Icon(CupertinoIcons.arrow_left));
  }

  @override
  Widget buildResults(BuildContext context) {
    return matchedQuery.isNotEmpty
        ? ListView.builder(
            itemCount: matchedQuery.length,
            itemBuilder: ((context, index) {
              var cur = matchedQuery[index];
              return Card(
                elevation: 5,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => DetailsPage(person: cur))));
                  },
                  title: Text(cur.name),
                ),
              );
            }))
        : "No items match your search".text.make().centered();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    matchedQuery.clear();
    for (UserData person in users) {
      if (query.isNotEmpty &&
          person.name.toLowerCase().contains(query.toLowerCase())) {
        matchedQuery.add(person);
      }
    }
    //these are the suggestions
    //all matching items are given as suggestion for now
    return matchedQuery.isNotEmpty
        ? ListView.builder(
            itemCount: matchedQuery.length,
            itemBuilder: ((context, index) {
              var cur = matchedQuery[index];
              return Card(
                  elevation: 5,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  DetailsPage(person: cur))));
                    },
                    title: Text(cur.name),
                  ));
            }))
        : "No items match your search".text.make().centered();
  }
}

class DetailsPage extends StatefulWidget {
  final UserData person;
  const DetailsPage({
    Key? key,
    required this.person,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState(this.person);
}

class _DetailsPageState extends State<DetailsPage> {
  final UserData currentPerson;

  _DetailsPageState(this.currentPerson);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "${currentPerson.name}'s Profile".text.make()),
      body: ListView(
        controller: ScrollController(),
        children: [
          SizedBox(
            height: 32,
          ),
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.accentColor, width: 3),
            ),
            child: Image.asset(
                "assets/images/avatar${currentPerson.avatarIndex}.png"),
          ),
          SizedBox(
            height: 16,
          ),
          currentPerson.name.text.lg.bold.make().centered(),
          SizedBox(
            height: 16,
          ),
          currentPerson.number.text.lg.bold.make().centered(),
          SizedBox(
            height: 32,
          ),
          ElevatedButton(
                  onPressed: (() {
                    print(currentPerson.avatarIndex);
                    //friend request code here
                    //also change the state from "add friend" to "request sent"
                  }),
                  child: "Add Friend".text.make())
              .pOnly(right: 16, left: 16)
        ],
      ),
    );
  }
}
