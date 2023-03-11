// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:khaata_app/models/my_map_data.dart';
import 'package:velocity_x/velocity_x.dart';

class FriendDetail extends StatefulWidget {
  final int id;
  const FriendDetail({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<FriendDetail> createState() => _FriendDetailState(this.id);
}

class _FriendDetailState extends State<FriendDetail> {
  final id;
  final amountController = TextEditingController();
  final remarksController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  _FriendDetailState(this.id);
  void initState() {
    super.initState();
    loadData(this.id);
  }

  loadData(int id) async {
    var currentHistory = TransactionData.myMap[id];
//    var detailJSON =
//        await rootBundle.loadString("assets/data/historydata.json");
//    var decodedData = jsonDecode(detailJSON);
//    var productsData = decodedData["history"];
//    var currentHistory = [];
//    for (var i = 0; i < productsData.length; i += 1) {
//      var cur = productsData[i];
//      if (cur["id"] == id) {
//        currentHistory = cur["data"];
//      }
//    }
//    HistoryModel.entry.id == id;
//    HistoryModel.entry.data.clear();
//    if (currentHistory == null) {
//      return;
//    }
//    for (var i = 0; i < currentHistory.length; i++) {
//      var cur = currentHistory[i];
//      HistoryModel.entry.data.add(SingleEntry.fromMap(cur));
//    }
//    setState(() {});
  }

  void addRecord() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    TransactionEntry cur = TransactionEntry(DateTime.now(),
        remarksController.text, int.parse(amountController.text));
    setState(() {
      TransactionData.addData(id, cur);
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          amountController.text = '';
          remarksController.text = '';
          showDialog(
              context: context,
              builder: ((context) {
                return Form(
                  key: _formKey,
                  child: AlertDialog(
                    title: Text("Enter the Details of new Transaction"),
                    content: Text("Use minus(-) sign for received amount"),
                    actions: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: "Amount",
                            hintText: "Enter the amount"),
                        controller: amountController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Amount cannot be empty");
                          } else {
                            RegExp pattern = RegExp(r'^[-+]?[0-9]+$');
                            if (!pattern.hasMatch(value)) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          }
                        },
                      ).pOnly(left: 16, right: 16),
                      TextFormField(
                        decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: "Remarks",
                            hintText: "Remarks about the transaction"),
                        controller: remarksController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Remarks cannot be empty");
                          } else if (value.length > 20) {
                            return ("Remarks is too long");
                          }
                          return null;
                        },
                      ).pOnly(left: 16, right: 16),
                      ButtonBar(children: [
                        TextButton(
                            child: Text("Cancel",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }
                            // save a transaction
                            ),
                        TextButton(
                            child: Text("Ok",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            style: ButtonStyle(),
                            onPressed: () {
                              addRecord();
                            }
                            // save a transaction
                            ),
                      ]),
                    ],
                  ),
                );
              }));
        },
        child: Icon(CupertinoIcons.add),
      ),
      appBar: AppBar(title: "Details of friend no ${id + 1}".text.make()),
      body: TransactionData.myMap[id] == null ||
              TransactionData.myMap[id]!.isEmpty
          ? "No Transactions for Friend ${id + 1}".text.bold.make().centered()
          : ListView.builder(
              itemCount: TransactionData.myMap[id]?.length,
              itemBuilder: ((context, index) {
                var cur = TransactionData.myMap[id]![index];
                return Card(
                  child: ListTile(
                    leading: Text(
                        "${cur.dateTime.year}-${cur.dateTime.month}-${cur.dateTime.day} ${cur.dateTime.hour}:${cur.dateTime.minute}"),
                    trailing: Text(cur.amount.toString()),
                    title: cur.remarks.text.make(),
                  ),
                );
              }),
            ),
    );
  }
}
