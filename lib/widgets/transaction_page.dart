import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transactions")),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
              elevation: 5,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(children: [
                      Row(children: [
                        "Source".text.lg.make().pOnly(right: 4),
                        Icon(Icons.arrow_forward, color: Colors.teal),
                        "Destination".text.lg.make().pOnly(left: 4),
                      ]).pOnly(bottom: 8, top: 8),
                      DateTime.now().toString().text.sm.make().p(8),
                    ]),
                    "Rs. Amount".text.xl.bold.make(),
                  ]));
        },
      ),
    );
  }
}
