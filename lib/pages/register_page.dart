import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
// New imports for back-end {Diwas}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khaata_app/backend/authentication.dart' ;
import 'package:khaata_app/models/structure.dart';
import 'package:crypto/crypto.dart' ;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String name = "" ;
  String passAgain = "" ;
  final _formKey = GlobalKey<FormState>();
  // Text Controllers
  TextEditingController namer = TextEditingController() ;
  TextEditingController numberer = TextEditingController() ;
  TextEditingController emailer = TextEditingController() ;
  TextEditingController passer = TextEditingController() ;
  // Switches
  bool ifItExists = false ;
  // Encrypt pin to a hash using SHA-256
  String generateHash(String text){
      var bytesOfData = utf8.encode(text) ;
      String hashValue = sha256.convert(bytesOfData).toString() ;
      return hashValue ;
  }

  // Add a new user using async method to push data in Firebase cloud
  Future addUser({required String name, required String email, required String number, required String password}) async{
    final database = FirebaseFirestore.instance.collection('user-data') ;
    final newUser = database.doc();
    final hash = generateHash(password);
    final user = UserData(id: newUser.id, name: name, number: number, email: email, hash: hash);
    // I made this class for conversion to and from JSON and this is how it's used
      final json = user.toJSON();
      newUser.set(json);
      Authentication().registerUser(email: email, password: password) ;
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
                  "Register",
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          if(ifItExists)
                            return ("Username already exists! ");
                          else
                            return ("Username cannot be empty.");
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: emailer,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        hintText: "Enter email address",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          if(ifItExists)
                            return ("Email already exists! ");
                          else
                            return ("Email address cannot be empty.");
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: numberer,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        hintText: "Enter phone number",
                      ),
                      maxLength: 10,
                      obscureText: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("The number cannot be empty! ");
                        } else if (value.length < 10) {
                          return ("The number must be of 10 digits! ");
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passer,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        hintText: "Enter password",
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("The password cannot be empty! ");
                        }
                        else if (value.length <= 8){
                          return ("Password is too short! ") ;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Confirm Password",
                        hintText: "Enter password again",
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("The password cannot be empty! ");
                        }
                        else if (value != passer.text.trim()) {
                          return ("The passwords don't match! ");
                        }
                        else{
                          passAgain = passer.text.trim() ;
                          return null ;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(onPressed: () {
                      String name1 = namer.text.trim();
                      String num1 = numberer.text.trim();
                      String pass = passer.text.trim() ;
                      String mail = emailer.text.trim() ;
                      if (!_formKey.currentState!.validate()) {
                            return;
                      }
                      setState(() {
                           addUser(name: name1, number: num1, email: mail, password: pass) ;
                      });
                      Navigator.pushNamed(context, "/login");
                      },
                        child: const Text('Register'),
                        style: TextButton.styleFrom(
                          minimumSize: const Size(150, 40)),
                    ),
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

