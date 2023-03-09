import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khaata_app/backend/transactionUtility.dart';
import 'package:khaata_app/backend/transactionsLoader.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:velocity_x/velocity_x.dart';

import '../backend/userbaseUtility.dart';
import '../models/structure.dart';
import '../models/transaction.dart';
import 'drawer.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(title: "Khaata".text.make(), actions: [
        IconButton(
            onPressed: (() {
              Navigator.pushNamed(context, "/notifications");
            }),
            icon: Icon(CupertinoIcons.bell))
      ]),
      body: Column(
        children: [
          "Your Summary".text.xl2.bold.make().p(8),
          MyPieChart().p(8),
          "Recents".text.xl2.bold.make().pOnly(top: 12, bottom: 12),
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
  List<Record> records = [];
  List<UserData> borrowers = [];
  List<UserData> lenders = [];
  var trans = TransactionLoader();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await trans.getDetailsOfParticipants().then((value) {
        if (mounted) {
          super.setState(() {
            records = trans.getRecords;
            borrowers = trans.getBorrowers;
            lenders = trans.getLenders;
            print(records);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return borrowers.isEmpty
        ? (records.isEmpty
            ? Center(child: "No recent transactions".text.lg.make())
            : const Center(child: CircularProgressIndicator()))
        : ListView.builder(
            itemCount: lenders.length,
            itemBuilder: ((context, index) {
              return ListTile(
                  title:
                      "${lenders[index].name} -----------> ${borrowers[index].name}"
                          .text
                          .lg
                          .make(),
                  subtitle:
                      "${TransactionRecord().days[records[index].transactionDate.toDate().weekday]}"
                              " - ${records[index].transactionDate.toDate().toString().substring(0, 16)}"
                          .text
                          .sm
                          .make(),
                  leading:
                      "${TransactionRecord().months[records[index].transactionDate.toDate().month]} "
                              "${records[index].transactionDate.toDate().day}"
                          .text
                          .sm
                          .make(),
                  // instead of using toDate() which shows shitty seconds and milliseconds nobody cares about !
                  trailing: "Amount : ${records[index].amount}".text.lg.make());
            })).pOnly(top: 10);
  }
}
