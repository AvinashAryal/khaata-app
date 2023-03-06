import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khaata_app/backend/authentication.dart';
import 'package:khaata_app/backend/userbaseUtility.dart';
import '../utils/themes.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final String? mail = Authentication().CurrentUser?.email ;
  final String? name = Authentication().CurrentUser?.displayName ;
  @override
  Widget build(BuildContext context) {
    final imageURL =
        "https://instagram.fktm1-1.fna.fbcdn.net/v/t51.2885-19/260491818_468831504724080_8594284692849237642_n.jpg?stp=dst-jpg_s150x150&_nc_ht=instagram.fktm1-1.fna.fbcdn.net&_nc_cat=100&_nc_ohc=QVMHfdMEHU4AX_LJD7n&edm=AOQ1c0wBAAAA&ccb=7-5&oh=00_AfBtVA6YlmUBH4e1RBI7CxCInHvHQL2UVP0ymPJ53b5TXg&oe=63F1EE92&_nc_sid=8fd12b";
    return Drawer(
      backgroundColor: MyTheme.lightColor,
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.all(0),
            child: UserAccountsDrawerHeader(
              margin: EdgeInsets.all(0),
              accountName: Text(
                "${name}",
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                "${mail}",
                style: TextStyle(color: Colors.white),
              ),
              currentAccountPicture: Icon(
                CupertinoIcons.profile_circled,
                color: Colors.white,
              ), //   CircleAvatar(
              //       backgroundImage: NetworkImage(imageURL),
              //     ),
            ),
          ),
          ListTile(
              leading: Icon(CupertinoIcons.home, color: Colors.white),
              title: Text(
                "Home",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              )),
          ListTile(
              leading:
                  Icon(CupertinoIcons.profile_circled, color: Colors.white),
              title: Text(
                "Profile",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
                onTap: (() async{
                  await Authentication().signOut() ;
                  Navigator.pushNamed(context, "/login");
                }),
                leading: Icon(CupertinoIcons.chevron_left_square_fill,
                    color: Colors.white),
                title: Text(
                  "Logout",
                  textScaleFactor: 1.2,
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }
}
