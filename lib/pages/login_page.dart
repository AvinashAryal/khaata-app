import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

// Back-end imports
import 'package:khaata_app/backend/userbaseUtility.dart';
import 'package:khaata_app/backend/authentication.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = "";
  bool wrongUser = true;
  bool hide = true ;
  bool wrongPass = false;
  String loggerMail = "0xFF";
  bool changeButton = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController namer = TextEditingController();
  TextEditingController passer = TextEditingController();

  // Backend utilities {Diwas - Don't mess with field names !}
  Future<void> getMailFromUsername(String name) async {
    await Userbase().getUserDetails("name", name).then((specified) {
      // Forget setState and I lost my shit - hahahaha !
      setState(() {
        loggerMail = specified.email;
        wrongUser = false; // this is needed and I know it !
      });
    }).catchError((error) {
      print(error);
      setState(() {
        wrongUser = true;
      });
    });
  }

  moveToHome(BuildContext context, bool givePass) async {
    if (!givePass) {
      setState(() {
        wrongPass = true;
      });
    } else {
      setState(() {
        wrongPass = false;
        changeButton = true;
      });
    }
    if (!_formKey.currentState!.validate()) {
      return;
    } else {
      await Future.delayed(const Duration(milliseconds: 500));
      var successfulSnackBar = SnackBar(
        content: "Successfully Logged In".text.color(Colors.green).make(),
        action: SnackBarAction(
          label: "DISMISS",
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(successfulSnackBar);
      await Navigator.pushNamed(context, "/home");
      Navigator.pop(context, "/login");
      setState(() {
        changeButton = false;
      });
    }
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
                  height: 200.0,
                  child: Image.asset("assets/images/khaata-logo.png"),
                ).pOnly(top: 40),
                Center(
                  child: Text(
                    "Welcome $name !",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(children: [
                    TextFormField(
                      controller: namer,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        hintText: "Enter username",
                      ),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Username cannot be empty.");
                        } else if (wrongUser) {
                          return ("Username is not found.");
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passer,
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
                          return ("Password cannot be empty.");
                        } else if (wrongPass) {
                          return ("Your password doesn't match! ");
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () {
                        name = namer.text.trim();
                        String pass = passer.text.trim();
                        getMailFromUsername(name).then((value) async {
                          print(
                              "$name\n$pass\n$loggerMail\n"); // Just for us devs - hahaha (your data is safe with us, lol !)
                          await Authentication().setInfoForCurrentUser(name);
                          moveToHome(
                              context,
                              await Authentication().signInUser(
                                  email: loggerMail, password: pass));
                        });
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
                            ? const Icon(
                                Icons.done,
                                color: Colors.white,
                              )
                            : const Text(
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
