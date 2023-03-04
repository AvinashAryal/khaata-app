import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khaata_app/widgets/friends_page.dart';
import 'package:khaata_app/widgets/search_bar.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:velocity_x/velocity_x.dart';

import '../widgets/dashboard.dart';
import '../widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> pages = [Dashboard(), FriendsList()];
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: currentPage == 0
            ? "Khaata".text.make()
            : "Your Friends".text.make(),
        actions: currentPage == 0
            ? [
                IconButton(
                    onPressed: (() {
                      Navigator.pushNamed(context, "/notifications");
                    }),
                    icon: Icon(CupertinoIcons.bell))
              ]
            : [FriendSerachBar()],
      ),
      drawer: MyDrawer(),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
              icon: Icon(
                CupertinoIcons.home,
              ),
              label: "Home"),
          NavigationDestination(
              icon: Icon(
                CupertinoIcons.group,
              ),
              label: "Friends"),
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
