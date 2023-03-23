// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khaata_app/backend/authentication.dart';
import 'package:khaata_app/backend/userbaseUtility.dart';
import 'package:khaata_app/models/transaction.dart';
import 'package:khaata_app/widgets/piechart.dart';
import 'package:velocity_x/velocity_x.dart';

// Back-end utilities - {Diwas}
import 'package:khaata_app/backend/transactionsLoader.dart';

import '../backend/transactionUtility.dart';
import '../models/structure.dart';

late UserData selected;

class FriendDetail extends StatefulWidget {
  final UserData details;
  FriendDetail({Key? key, required this.details}) : super(key: key) {
    selected = details;
  }

  @override
  State<FriendDetail> createState() => _FriendDetailState();
}

class _FriendDetailState extends State<FriendDetail> {
  List<Record> friendAssocRecords = [];
  final amountController = TextEditingController();
  final remarksController = TextEditingController();
  final paymentRequestRemarksController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _paymentRequestFormKey = GlobalKey<FormState>();
  var trLoader = TransactionLoader() ;
  var inBal, outBal ;

  // Add a new user using async method to push data in Firebase cloud
  Future addRecord(
      {required String lenderID,
      required String borrowerID,
      required int amount,
      required String remarks}) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final Record rec = Record(
        transactionID: '',
        borrowerID: borrowerID,
        lenderID: lenderID,
        transactionDate: Timestamp.now(),
        amount: amount,
        remarks: remarks);
    await TransactionRecord().createNewRecord(rec);
    if (lenderID == Authentication().currentUser?.uid) {
      await Userbase().incrementCurrentUserValue('outBalance', amount);
      await Userbase()
          .incrementSpecificUserValue(borrowerID, 'inBalance', amount);
    } else {
      await Userbase().incrementCurrentUserValue('inBalance', amount);
      await Userbase()
          .incrementSpecificUserValue(lenderID, 'outBalance', amount);
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await trLoader
          .getTransactionsAssocTo(selected.id as String)
          .then((value) {
        if (mounted) {
          super.setState(() {
            friendAssocRecords = trLoader.getRecords;
            inBal = 0;
            outBal = 0;
            for (int i = 0; i < friendAssocRecords.length; i++) {
              if (friendAssocRecords[i].lenderID ==
                  Authentication().currentUser?.uid) {
                outBal += friendAssocRecords[i].amount;
              } else {
                inBal += friendAssocRecords[i].amount;
              }
            }
          });
        }
      });
    });
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
                    title: Text("Enter the details of new transaction"),
                    content: Text("Specify a short remark in 20 characters "),
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
                          } else if (value.length > 21) {
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
                            child: Text("OK",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            style: ButtonStyle(),
                            onPressed: () async{
                              // add records here
                              String tAmount = amountController.text.trim() ;
                              String tRemarks = remarksController.text.trim() ;
                              await addRecord(lenderID: Authentication().currentUser?.uid as String,
                                                borrowerID: selected.id as String,
                                                amount: int.parse(tAmount), remarks: tRemarks) ;
                              // refresh to dashboard to give update some time
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
      appBar: AppBar(title: "Details of ${selected.name}".text.make()),
      body: friendAssocRecords.isEmpty ? "No transactions associated to ${selected.name}".text.bold.make().centered()
          : Stack(children:[
            ListView.builder(
              padding: EdgeInsets.only(bottom: 100),
              itemCount: friendAssocRecords.length+1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(children: [
                    MyPieChart(association: true, posBal: outBal, negBal: inBal),
                    outBal - inBal <= 0 ? "Net balance with ${selected.name}: ${outBal - inBal}".text.lg.bold.red500.make() :
                    "Net balance with ${selected.name}: ${outBal - inBal}".text.lg.bold.green500.make()
                  ],) ;
                }
                return Card(
                    elevation: 5,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(children: [
                                  "${friendAssocRecords[index-1].lenderID == Authentication().currentUser?.uid
                                      ? Authentication().currentUser?.displayName : selected.name }"
                                      .text
                                      .lg
                                      .make()
                                      .pOnly(right: 4),
                                  friendAssocRecords[index-1].lenderID == Authentication().currentUser?.uid
                                      ? Icon(Icons.arrow_forward, color: Colors.teal) :
                                        Icon(Icons.arrow_forward, color: Colors.red),
                                  "${friendAssocRecords[index-1].borrowerID == Authentication().currentUser?.uid
                                      ? Authentication().currentUser?.displayName : selected.name }"
                                      .text
                                      .lg
                                      .make()
                                      .pOnly(left: 4),
                                ]).pOnly(bottom: 8, top: 8),
                                "${TransactionRecord().days[friendAssocRecords[index-1].transactionDate.toDate().weekday]}"
                                    " - ${friendAssocRecords[index-1].transactionDate.toDate().toString().substring(0, 16)}"
                                    .text
                                    .sm
                                    .make(),
                              ]),

                          "${friendAssocRecords[index-1].remarks}".text.xl.make(),
                          "${friendAssocRecords[index-1].amount}".text.bold.xl.make(),
                        ]).pOnly(right: 16, left: 16, top: 8, bottom: 8)
                );
              },
            ),
          Positioned(
                bottom: 0, // Adjust this value to change the button's position
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: context.theme.hoverColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Net Balance: ${outBal-inBal}"
                          .text
                          .lg
                          .bold
                          .make()
                          .pOnly(bottom: 20, top: 20, left: 20),
                      ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Form(
                                      key: _paymentRequestFormKey,
                                      child: Center(
                                        child: SingleChildScrollView(
                                          child: AlertDialog(
                                            title: Text("Add a note"),
                                            actions: [
                                              TextFormField(
                                                decoration: InputDecoration(
                                                    alignLabelWithHint: true,
                                                    labelText: "Remarks",
                                                    hintText:
                                                        "Remarks about the request"),
                                                controller:
                                                    paymentRequestRemarksController,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return ("Remarks cannot be empty");
                                                  } else if (value.length >
                                                      20) {
                                                    return ("Remarks is too long");
                                                  }
                                                  return null;
                                                },
                                              ).pOnly(left: 16, right: 16),
                                              ButtonBar(children: [
                                                TextButton(
                                                    child: Text("Cancel",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                    // save a transaction
                                                    ),
                                                TextButton(
                                                    child: Text("OK",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    style: ButtonStyle(),
                                                    onPressed: () async {
                                                      // add notification for request here
                                                    }

                                                    ),
                                              ]),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: 'Request to pay'.text.make())
                          .pOnly(bottom: 20, right: 100, top: 20),
                    ],
                  ),
                ),
            )
          ]
          )
        );
  }
}
