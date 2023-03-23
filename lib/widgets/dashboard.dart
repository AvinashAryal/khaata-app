import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khaata_app/backend/transactionUtility.dart';
import 'package:khaata_app/backend/transactionsLoader.dart';
import 'package:khaata_app/backend/userbaseUtility.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:velocity_x/velocity_x.dart';

// Imports
import '../backend/authentication.dart';
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

class MyPieChart extends StatefulWidget {
  const MyPieChart({Key? key}) : super(key: key);

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  var pos, neg;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await Userbase()
          .getUserDetails('id', Authentication().currentUser?.uid as String)
          .then((value) {
        if (mounted) {
          super.setState(() {
            pos = value.outBalance.toDouble();
            neg = value.inBalance.toDouble();
          });
          print(pos);
          print(neg);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Userbase()
        .getUserDetails('id', Authentication().currentUser?.uid as String);
    return PieChart(
      dataMap: {
        "Outflows": pos == null ? 1.0 : pos,
        "Inflows": neg == null ? 0.0 : neg
      },
      colorList: [Colors.greenAccent, Colors.redAccent],
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
      await trans.getDetailsOfParticipants(true).then((value) {
        if (mounted) {
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
    return borrowers.isEmpty
        ? (records.isEmpty
            ? Center(child: "No recent transactions".text.lg.make())
            : const Center(child: CircularProgressIndicator()))
        : ListView.builder(
            itemCount: lenders.length,
            itemBuilder: ((context, index) {
              return Card(
                child: ListTile(
                    leading:
                        "${TransactionRecord().months[records[index].transactionDate.toDate().month - 1]}"
                                " ${records[index].transactionDate.toDate().day}"
                            .text
                            .lg
                            .make(),
                    title: Row(children: [
                      "${lenders[index].name}".text.lg.make(),
                      lenders[index].id == Authentication().currentUser?.uid
                          ? Icon(Icons.arrow_forward, color: Colors.teal)
                          : Icon(Icons.arrow_forward, color: Colors.red),
                      "${borrowers[index].name}".text.lg.make()
                    ]),
                    subtitle:
                        "${TransactionRecord().days[records[index].transactionDate.toDate().weekday]}"
                                " - ${records[index].transactionDate.toDate().toString().substring(0, 16)}"
                            .text
                            .sm
                            .make(),
                    // instead of using toDate() which shows shitty seconds and milliseconds nobody cares about !
                    trailing: "${records[index].amount}".text.lg.bold.make()),
              );
            })).pOnly(top: 10);
  }
}
