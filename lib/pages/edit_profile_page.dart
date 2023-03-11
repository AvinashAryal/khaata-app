import 'package:flutter/material.dart';
import 'package:khaata_app/widgets/drawer.dart';
import 'package:velocity_x/velocity_x.dart';

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
                darkmode = value;
                setState(() {});
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
        itemCount: 8,
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

class ChangePassWordButton extends StatelessWidget {
  const ChangePassWordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: ((context) {
                return SingleChildScrollView(
                  child: AlertDialog(
                    title: Text("Change Password"),
                    actions: [
                      TextField(
                        decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: "Old Password",
                            hintText: "Enter Old Password"),
                      ).pOnly(left: 16, right: 16),
                      TextField(
                        decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: "New Password",
                            hintText: "Enter New Password"),
                      ).pOnly(left: 16, right: 16),
                      TextField(
                        decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: "Confirm New Password",
                            hintText: "Enter New Password Again"),
                      ).pOnly(left: 16, right: 16),
                      TextButton(
                          child: Text("Ok",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ButtonStyle(),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }
                          // save a transaction
                          )
                    ],
                  ),
                );
              }));
        },
        child:
            "Change Password".text.semiBold.make().pOnly(right: 24, left: 24));
  }
}
