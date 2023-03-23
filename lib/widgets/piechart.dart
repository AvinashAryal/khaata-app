import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:velocity_x/velocity_x.dart';

import '../backend/authentication.dart';
import '../backend/userbaseUtility.dart';

bool assoc = false ;
var positive, negative ;

class MyPieChart extends StatefulWidget {
  MyPieChart({Key? key, required bool association, var posBal, var negBal}) : super(key: key){
    assoc = association ;
    positive = posBal ;
    negative = negBal ;
  }

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  var pos, neg ;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if(assoc){
        setState(() {
          pos = positive ;
          neg = negative ;
        });
      }
      else {
        await Userbase().getUserDetails(
            'id', Authentication().currentUser?.uid as String).then((value) {
          if (mounted) {
            super.setState(() {
              pos = value.outBalance;
              neg = value.inBalance;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Userbase().getUserDetails('id', Authentication().currentUser?.uid as String) ;
    return PieChart(
      dataMap: {"Outflows": pos == null ? 0 : pos, "Inflows": neg == null ? 0 : neg},
      colorList: [Colors.greenAccent, Colors.redAccent],
      legendOptions: LegendOptions(showLegends: false),
    ).box.square(200).rounded.make();
  }
}



