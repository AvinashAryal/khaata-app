class TransactionData {
  static Map<int, List<TransactionEntry>> myMap = {};
  TransactionData(myMap);
  static void addData(int id, TransactionEntry transactionEntry) {
    if (myMap[id] == null) {
      myMap[id] = [transactionEntry];
      return;
    }
    myMap[id]?.add(transactionEntry);
  }
}

class TransactionEntry {
  final DateTime dateTime;
  final String remarks;
  final int amount;

  TransactionEntry(this.dateTime, this.remarks, this.amount);
}
