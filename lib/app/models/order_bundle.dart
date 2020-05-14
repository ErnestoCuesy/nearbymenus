class OrderBundle {
  final String id;
  final String purchaseDate;
  final String rcInfo;
  final int orders;

  OrderBundle({this.id, this.purchaseDate, this.rcInfo, this.orders});

  factory OrderBundle.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    return OrderBundle(
      id: data['id'],
      purchaseDate: data['purchaseDate'],
      rcInfo: data['rcInfo'],
      orders: data['orders'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'purchaseDate': purchaseDate,
      'rcInfo': rcInfo,
      'orders': orders,
    };
  }

}