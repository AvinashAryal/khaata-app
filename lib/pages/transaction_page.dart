import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../backend/transactionUtility.dart';
import '../backend/transactionsLoader.dart';
import '../models/structure.dart';
import '../models/transaction.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {

  List<Record> records = [] ;
  List<UserData> borrowers = [] ;
  List<UserData> lenders = [] ;
  var trans = TransactionLoader() ;

  @override
  void initState(){
    super.initState() ;
    Future.delayed(Duration.zero,() async {
      await trans.getDetailsOfParticipants(false).then((value){
        if(mounted) {
          super.setState(() {
            records = trans.getRecords;
            borrowers = trans.getBorrowers;
            lenders = trans.getLenders;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transactions")),
      body: records.isEmpty ? Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          return Card(
              elevation: 5,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(children: [
                      Row(children: [
                        "${TransactionRecord().days[records[index].transactionDate.toDate().weekday]}"
                            .text.xl.make().pOnly(right: 2),
                        "${TransactionRecord().months[records[index].transactionDate.toDate().month]} "
                            "${records[index].transactionDate.toDate().day}".text.xl.make(),
                        "${lenders[index].name}".text.lg.make().pOnly(right: 4),
                        Icon(Icons.arrow_forward, color: Colors.teal),
                        "${borrowers[index].name}".text.lg.make().pOnly(left: 4),
                      ]).pOnly(bottom: 8, top: 8),
                        "${records[index].transactionDate.toDate().toString().substring(0,16)}".text.make().p(8),
                    ]),
                    "${records[index].amount}".text.xl.bold.make(),
                  ]));
        },
      ),
    );
  }
}
