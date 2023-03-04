import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khaata_app/backend/authentication.dart';
import 'package:velocity_x/velocity_x.dart';

import '../models/structure.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = "";
  bool changeButton = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailer = TextEditingController() ;
  TextEditingController passer = TextEditingController() ;

  /*
  UserData getMailFromUsername(String name){
    final reference = FirebaseFirestore.instance.collection('user-data') ;
    reference.doc(name).get().then((DocumentSnapshot doc) => {
      UserData logger = UserData.fromJSON(doc.data()) ;
      return logger ;
    }) ;
  }
  */

  moveToHome(BuildContext context, Future<bool> givePass) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      changeButton = true;
    });
    if(await givePass) {
      await Future.delayed(const Duration(milliseconds: 500));
      await Navigator.pushNamed(context, "/");
      Navigator.pop(context, "/login");
      setState(() {
        changeButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.canvasColor,
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 60.0,
                ),
                Text(
                  "Welcome $name!",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                  child: Column(children: [
                    TextFormField(
                      controller: emailer,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        hintText: "Enter email address",
                      ),
                      onChanged: (value) => {name = value, setState(() {})},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Email address cannot be empty.");
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passer,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        hintText: "Enter password",
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Password cannot be empty.");
                        } else if (value.length < 8) {
                          return ("Password is too short");
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: (){
                          String mail = emailer.text.trim() ;
                          String pass = passer.text.trim() ;
                          moveToHome(context, Authentication().signInUser(email: mail, password: pass)) ;
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: changeButton ? 50 : 100,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius:
                              BorderRadius.circular(changeButton ? 50 : 16),
                        ),
                        child: changeButton
                            ? Icon(
                                Icons.done,
                                color: Colors.white,
                              )
                            : Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ),
                    TextButton(
                        onPressed: (() {
                          Navigator.pushNamed(context, "/register");
                        }),
                        child: Text("Not registered? Register"))
                    //   ElevatedButton(
                    //     child: Text("Login"),
                    //     style: TextButton.styleFrom(minimumSize: const Size(150, 40)),
                    //     onPressed: () {
                    //       Navigator.pushNamed(context, MyRoutes.homeRoute);
                    //     },
                    //   )
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
