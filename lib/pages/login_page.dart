import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khaata_app/backend/authentication.dart';
import 'package:velocity_x/velocity_x.dart';

import '../models/structure.dart';
import 'package:khaata_app/backend/userbaseUtility.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = "";
  String loggerMail = "0xFF" ;
  bool changeButton = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController namer = TextEditingController() ;
  TextEditingController passer = TextEditingController() ;

  // Backend utilities {Diwas - Don't mess with field names !}
  Future<void> getMailFromUsername (String name) async{
    await Userbase().getUserDetails("name", name).then((specified) {
      // Forget setState and I lost my shit - hahahaha !
      setState(() {
        loggerMail = specified.email ;
      });
    }) ;
  }

  moveToHome(BuildContext context, Future<bool> givePass) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      changeButton = true;
    });
    if(await givePass) {
      await Future.delayed(const Duration(milliseconds: 50));
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
                      controller: namer,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        hintText: "Enter username",
                      ),
                      onChanged: (value) => {name = value, setState(() {})},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Username cannot be empty.");
                        }
                        else if (value == "0xFF"){
                          return ("Username is not found.") ;
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
                          String name = namer.text.trim() ;
                          String pass = passer.text.trim() ;
                          getMailFromUsername(name).then((value) {
                            print("$name\n$pass\n$loggerMail"); // Just for us devs - hahaha (your data is safe with us, lol !)
                            moveToHome(context, Authentication().signInUser(email: loggerMail, password: pass));
                          }) ;
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
