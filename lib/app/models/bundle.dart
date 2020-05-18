class Bundle {
  final String id;
  final String purchaseDate;
  final String rcInfo;
  final int ordersInBundle;

  Bundle({this.id, this.purchaseDate, this.rcInfo, this.ordersInBundle});

  factory Bundle.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    return Bundle(
      id: data['id'],
      purchaseDate: data['purchaseDate'],
      rcInfo: data['rcInfo'],
      ordersInBundle: data['ordersInBundle'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'purchaseDate': purchaseDate,
      'rcInfo': rcInfo,
      'ordersInBundle': ordersInBundle,
    };
  }

}