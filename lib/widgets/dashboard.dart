import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khaata_app/backend/transactionUtility.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:velocity_x/velocity_x.dart';

import '../backend/authentication.dart';
import '../backend/userbaseUtility.dart';
import '../models/structure.dart';
import '../models/transaction.dart';
import 'drawer.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          "Your Summary".text.bold.lg.make().p(8),
          MyPieChart().p(8),
          "Recents".text.xl2.bold.make(),
          RecentList().expand(),
        ],
      ),
    );
  }
}

class MyPieChart extends StatelessWidget {
  const MyPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: {"Positive": 5, "Negative": 3},
      colorList: [Colors.redAccent, Colors.greenAccent],
      legendOptions: LegendOptions(showLegends: false),
    ).box.square(200).rounded.make();
  }
}

// {Diwas - Changed it to stateful as it needs async updates everytime the page opens}
class RecentList extends StatefulWidget {
  const RecentList({Key? key}) : super(key: key);

  @override
  State<RecentList> createState() => _RecentListState();
}

class _RecentListState extends State<RecentList> {
  List<Record> records = [] ;
  List<UserData> borrowers = [] ;
  List<UserData> lenders = [] ;

  void initState(){
    super.initState() ;
    getDetailsOfParticipants() ;
  }

  Future<void> getPastTransactions () async{
    await TransactionRecord().getRecentRecords(5).then((specified){
      records = specified ;
    }) ;
  }

  Future<void> getDetailsOfParticipants() async{
    await getPastTransactions() ;
    for(var i=0; i<records.length; i++){
      await Userbase().getUserDetails("id", records[i].lenderID.toString()).then((value){
        setState(() {
          lenders.insert(i, value) ;
        });
      }) ;
      await Userbase().getUserDetails("id", records[i].borrowerID.toString()).then((value){
        setState(() {
          borrowers.insert(i, value) ;
        });
      }) ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: lenders.length,
        itemBuilder: ((context, index) {
          return ListTile(
              title: "${lenders[index].name} -----------> ${borrowers[index].name}".text.sm.make(),
              leading: "${records[index].transactionDate.toDate()}".text.sm.make(),
              trailing: "Amount => ${records[index].amount}".text.sm.make()
          );
        })).pOnly(top: 10);
  }
}

