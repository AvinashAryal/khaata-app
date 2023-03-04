import 'package:flutter/material.dart';
import 'package:khaata_app/pages/friends_details_page.dart';
import 'package:khaata_app/pages/login_page.dart';
import 'package:khaata_app/pages/home_page.dart';
import 'package:khaata_app/utils/themes.dart';

// Importing Firebase
import 'package:firebase_core/firebase_core.dart' ;

/* Yeah - I'm gonna make the main function ~ asychronous !
 [ !!! WARNING {Diwas} - Don't mess with Firebase Options and API keys !!! ]
 */
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(
      apiKey: "AIzaSyBQpiMuk5ELTQDxRl-bGzI65EtkDwPwe2w",
      appId: "1:800158423272:android:56c2d440ccd3ebfa0ad15d",
      messagingSenderId: "800158423272",
      projectId: "khaata-3bs")
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: MyTheme.LightTheme(context),
      darkTheme: MyTheme.DarkTheme(context),
      initialRoute: "/login",
      routes: {
        "/": (context) => HomePage(),
        "/login": (context) => LoginPage(),
      },
    );
  }
}
