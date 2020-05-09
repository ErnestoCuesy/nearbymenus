class OrderItem {
  final String id;
  final String orderId;
  final String name;
  final int quantity;
  final double price;
  final double total;
  final List<String> options;

  OrderItem({this.id, this.orderId, this.name, this.quantity, this.options, this.price, this.total});

  factory OrderItem.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    List<String> options;
    if (data['options'] != null) {
      options = List.from(data['options']);
    } else {
      options = List<String>();
    }
    return OrderItem(
      id: data['id'],
      orderId: data['orderId'],
      name: data['name'],
      quantity: data['quantity'],
      price: data['price'],
      total: data['total'],
      options: options,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'total': total,
      'options': options ?? [],
    };
  }

  @override
  String toString() {
    return 'id: $id, orderId: $orderId, name: $name, quantity: $quantity, price: $price, total: $total, options: $options';
  }

}
