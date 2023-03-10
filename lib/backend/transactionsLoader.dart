
import 'package:khaata_app/backend/transactionUtility.dart';
import 'package:khaata_app/backend/userbaseUtility.dart';

import '../models/structure.dart';
import '../models/transaction.dart';

/*
 Author: Diwas Adhikari
 {I am a sucker for classes and getters/setters - it sucks that I don't know if templates exist in Dart !}
 */

class TransactionLoader{
    List<Record> records = [] ;
    List<UserData> borrowers = [] ;
    List<UserData> lenders = [] ;

    List<Record> get getRecords => records ;
    List<UserData> get getBorrowers => borrowers ;
    List<UserData> get getLenders => lenders ;

    Future<void> getPastTransactions() async{
      await TransactionRecord().getRecentLendRecords(2).then((specified){
        records = specified;
      }) ;
      await TransactionRecord().getRecentBorrowRecords(2).then((specified){
        records = records + specified ;
      }) ;
    }

    Future<void> getDetailsOfParticipants() async {
    await getPastTransactions();
    for (var i = 0; i < records.length; i++) {
      await Userbase()
        .getUserDetails("id", records[i].lenderID.toString())
        .then((value) {
          lenders.insert(i, value);
      });
      await Userbase()
        .getUserDetails("id", records[i].borrowerID.toString())
        .then((value) {
          borrowers.insert(i, value);
      });
    }
  }
}