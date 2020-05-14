class OrderCounter {
  int ordersLeft;
  String lastUpdated;

  OrderCounter({this.ordersLeft, this.lastUpdated});

  factory OrderCounter.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    return OrderCounter(
      ordersLeft: data['ordersLeft'],
      lastUpdated: data['lastUpdated'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ordersLeft': ordersLeft,
      'lastUpdated': lastUpdated,
    };
  }

}