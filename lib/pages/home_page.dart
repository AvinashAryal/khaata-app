import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khaata_app/pages/friends_page.dart';
import 'package:khaata_app/pages/transaction_page.dart';

import '../widgets/dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> pages = [Dashboard(), FriendsPage(), TransactionPage()];
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: "Home"),
          NavigationDestination(
              icon: Icon(
                CupertinoIcons.person_2_fill,
              ),
              label: "Friends"),
          NavigationDestination(
              icon: Icon(CupertinoIcons.arrow_2_squarepath),
              label: "Transactions"),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
      body: pages[currentPage],
    );
  }
}
