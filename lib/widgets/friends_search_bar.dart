import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khaata_app/models/structure.dart';
import 'package:velocity_x/velocity_x.dart';

import '../backend/friendsLoader.dart';
import '../backend/userbaseUtility.dart';

class FriendSearchBar extends StatefulWidget {
  const FriendSearchBar({super.key});

  @override
  State<FriendSearchBar> createState() => _FriendSearchBarState();
}

class _FriendSearchBarState extends State<FriendSearchBar> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showSearch(context: context, delegate: CustomSearchDelegate());
      },
      child: Column(children: [
        Divider().pOnly(top: 4),
        ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          children: ["Search your friends".text.lg.make(), Icon(Icons.search)],
        ),
        Divider().pOnly(top: 4)
      ]),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {

  // Back-end data fetch {Diwas - "Yeah this is how we do it !"}
  List<UserData> friends = [] ;
  List<UserData> matchedQuery = [] ;
  var frLoad = FriendLoader() ;

  @override
  List<Widget>? buildActions(BuildContext context) {
    //clear query
    return [
      IconButton(
          onPressed: (() {
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
          close(context, null);
        }),
        icon: Icon(CupertinoIcons.arrow_left));
  }

  @override
  Widget buildResults(BuildContext context) {
    friends = frLoad.fetchFriendDetails ;
    print(friends) ;
    for (UserData person in friends) {
      if (person.name.toLowerCase().contains(query.toLowerCase())) {
        matchedQuery.add(person);
      }
    }
    return matchedQuery.isNotEmpty
        ? ListView.builder(
            itemCount: matchedQuery.length,
            itemBuilder: ((context, index) {
              var cur = matchedQuery[index].name ;
              return Card(
                elevation: 5,
                child: ListTile(
                  title: Text(cur),
                  trailing: IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: (() {
                      // We might load profile of a friend {Diwas}
                    }),
                  ),
                ),
              );
            }))
        : "No items match your search".text.make().centered();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //these are the suggestions
    //all matching items are given as suggestion for now
    return matchedQuery.isNotEmpty
        ? ListView.builder(
            itemCount: matchedQuery.length,
            itemBuilder: ((context, index) {
              var cur = matchedQuery[index].name ;
              return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(cur),
                  ));
            }))
        : "No items match your search".text.make().centered();
  }
}
