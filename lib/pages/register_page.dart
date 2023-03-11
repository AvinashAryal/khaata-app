import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
// New imports for back-end {Diwas}
import 'package:khaata_app/backend/authentication.dart';
import 'package:khaata_app/backend/userbaseUtility.dart';
import 'package:khaata_app/models/structure.dart';
import 'package:khaata_app/utils/hash.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String name = "";
  String passAgain = "";
  final _formKey = GlobalKey<FormState>();
  // Text Controllers
  TextEditingController namer = TextEditingController();
  TextEditingController numberer = TextEditingController();
  TextEditingController emailer = TextEditingController();
  TextEditingController passer = TextEditingController();
  // Switches
  bool ifItExists = false ;
  bool hide = true ;


  // Add a new user using async method to push data in Firebase cloud
  Future addUser(
      {required String name,
      required String email,
      required String number,
      required String password}) async {
    final hash = Hash().generateHash(password) ;
    // I just remade this thing again with new classes - life is awful !
    await Authentication().registerUser(email: email, password: password);
    final user = UserData(
        id: Authentication().currentUser?.uid,
        name: name,
        number: number,
        email: email,
        hash: hash,
        friends: []);
    await Userbase().createNewUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  child: Image.asset("assets/images/khaata-logo.png"),
                ).pOnly(top: 20),
                const Center(
                  child: Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 32.0),
                  child: Column(children: [
                    TextFormField(
                      controller: namer,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        hintText: "Enter username",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          if (ifItExists) {
                            return ("Username already exists! ");
                          } else {
                            return ("Username cannot be empty.");
                          }
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
                          if (ifItExists) {
                            return ("Email already exists! ");
                          } else {
                            return ("Email address cannot be empty.");
                          }
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
                        } else if (value.length != 10) {
                          return ("The number must be of 10 digits! ");
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passer,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Enter password",
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              hide = !hide ;
                            });
                          },
                          icon: hide ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                        ),
                      ),
                      obscureText: hide,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("The password cannot be empty! ");
                        } else if (value.length <= 8) {
                          return ("Password is too short! ");
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        hintText: "Enter password again",
                      ),
                      obscureText: hide,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("The password cannot be empty! ");
                        } else if (value != passer.text.trim()) {
                          return ("The passwords don't match! ");
                        } else {
                          passAgain = passer.text.trim();
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                      onPressed: () {
                        String name1 = namer.text.trim();
                        String num1 = numberer.text.trim();
                        String pass = passer.text.trim();
                        String mail = emailer.text.trim();
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        setState(() {
                          addUser(
                              name: name1,
                              number: num1,
                              email: mail,
                              password: pass);
                        });
                        var successfulSnackBar = SnackBar(
                          content: "Successfully Registered"
                              .text
                              .color(Colors.green)
                              .make(),
                          action: SnackBarAction(
                            label: "DISMISS",
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(successfulSnackBar);
                        Navigator.pushNamed(context, "/login");
                        Navigator.pop(context, "/register");
                      },
                      child: "Register".text.xl.make(),
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
