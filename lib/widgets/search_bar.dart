import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class FriendSearchBar extends StatefulWidget {
  const FriendSearchBar({super.key});

  @override
  State<FriendSearchBar> createState() => _FriendSearchBarState();
}

class _FriendSearchBarState extends State<FriendSearchBar> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showSearch(context: context, delegate: CustomSearchDelegate());
        },
        icon: const Icon(CupertinoIcons.search));
  }
}

class CustomSearchDelegate extends SearchDelegate {
  //list of search terms
  List<String> searchTerms = ["diwas", "avinash", "Alice", "Bob"];

  // Back-end data fetch {Diwas - "Yeah this is how we do it !"}


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
    //List of matched results
    // to be modified when firebase is implemented
    List<String> matchedQuery = [];
    for (var person in searchTerms) {
      if (person.toLowerCase().contains(query.toLowerCase())) {
        matchedQuery.add(person);
      }
    }
    return matchedQuery.isNotEmpty
        ? ListView.builder(
            itemCount: matchedQuery.length,
            itemBuilder: ((context, index) {
              var cur = matchedQuery[index];
              return ListTile(
                title: Text(cur),
              );
            }))
        : "No items match your search".text.make().centered();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //these are the suggestions
    //all matching items are given as suggestion for now
    List<String> matchedQuery = [];
    for (var person in searchTerms) {
      if (person.toLowerCase().contains(query.toLowerCase())) {
        matchedQuery.add(person);
      }
    }
    return matchedQuery.isNotEmpty
        ? ListView.builder(
            itemCount: matchedQuery.length,
            itemBuilder: ((context, index) {
              var cur = matchedQuery[index];
              return ListTile(
                title: Text(cur),
              );
            }))
        : "No items match your search".text.make().centered();
  }
}
