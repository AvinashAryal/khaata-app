import 'package:flutter/material.dart';
import 'package:khaata_app/backend/authentication.dart';
import 'package:khaata_app/widgets/drawer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../backend/userbaseUtility.dart';
import '../utils/hash.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool darkmode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: "Edit Your Profile".text.make(),
        actions: [
          Icon(Icons.dark_mode_sharp),
          Switch(
              value: darkmode,
              onChanged: ((value) {
                setState(() {
                  darkmode = value;
                });
              }))
        ],
      ),
      body: ListView(
        children: [Avatar(), Divider(), ChangePassWordButton()],
      ),
    );
  }
}

class Avatar extends StatefulWidget {
  const Avatar({super.key});

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  static int currentImage = 0;
  int selectedImage = -1;
  String url = "assets/images/avatar${currentImage + 1}.png";
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SizedBox(height: 150, width: 150, child: Image.asset(url))
          .pOnly(top: 36, bottom: 12),
      "Select Avatar".text.lg.bold.make().p(12),
      GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, crossAxisSpacing: 30),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 8     ,
        itemBuilder: (context, index) {
          return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedImage = index;
                    });
                  },
                  child: (selectedImage != -1 && selectedImage == index)
                      ? Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.lightBlueAccent, width: 3)),
                          child: Image.asset(
                              "assets/images/avatar${index + 1}.png"),
                        )
                      : Image.asset("assets/images/avatar${index + 1}.png"))
              .p(4);
        },
      ).pOnly(
        left: 24,
        right: 24,
      ),
      ElevatedButton(
              onPressed: () {
                if (selectedImage == -1) {
                  return;
                }
                setState(() {
                  url = "assets/images/avatar${selectedImage + 1}.png";
                });
              },
              style: ElevatedButton.styleFrom(shape: StadiumBorder()),
              child: "Change Avatar".text.make())
          .p(16)
    ]);
  }
}

class ChangePassWordButton extends StatefulWidget {
  const ChangePassWordButton({Key? key}) : super(key: key);

  @override
  State<ChangePassWordButton> createState() => _ChangePassWordButtonState();
}

class _ChangePassWordButtonState extends State<ChangePassWordButton> {
  TextEditingController previous = TextEditingController() ;
  TextEditingController next = TextEditingController() ;
  String again = "" ;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: ((context) {
                return AlertDialog(
                  title: Text("Change Password"),
                  actions: [
                    Form(
                      key: _formKey,
                    child: Column(
                        children: [
                      TextFormField(
                      controller: previous,
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelText: "Old Password",
                          hintText: "Enter Old Password"),
                    ).pOnly(left: 16, right: 16),
                    TextFormField(
                      controller: next,
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelText: "New Password",
                          hintText: "Enter New Password"),
                          validator: (value) {
                            if (value!.isEmpty) {
                               return ("The password cannot be empty! ");
                            } else if (value.length <= 8) {
                               return ("Password is too short! ");
                            }
                               return null;
                          },
                    ).pOnly(left: 16, right: 16),
                    TextFormField(
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelText: "Confirm New Password",
                          hintText: "Enter New Password Again"),
                          validator: (value) {
                            if (value!.isEmpty) {
                            return ("The password cannot be empty! ");
                            } else if (value != next.text.trim()) {
                            return ("The passwords don't match! ");
                            } else {
                            again = next.text.trim();
                            return null;
                            }
                        }
                      ).pOnly(left: 16, right: 16),
                        ]
                      )
                    ),
                    TextButton(
                        child: Text("OK",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ButtonStyle(),
                        onPressed: () async{
                            String old = previous.text.trim() ;
                            String now = next.text.trim() ;
                            String hashNew = "" ;
                            old = Hash().generateHash(old) ;
                            hashNew = Hash().generateHash(now) ;

                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            await Authentication().currentUser?.updatePassword(now) ;
                            Userbase().updateUserDetails("hash", hashNew) ;
                            Navigator.of(context).pop();

                            // Let the user know that it actually changed - HAHAHA !
                            var successfulSnackBar = SnackBar(
                              content: "Password updated successfully! "
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
                        }
                      )
                  ],
                );
              }));
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: "Change Password".text.semiBold.make(),
        ).pOnly(right: 24, left: 24));
    }

}
