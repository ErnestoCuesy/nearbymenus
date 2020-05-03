class Item {
  final String id;
  final String menuId;
  final String name;
  final String description;
  final double price;
  final bool isExtra;
  final bool isSide;

  Item({
    this.id,
    this.menuId,
    this.name,
    this.description,
    this.price,
    this.isExtra,
    this.isSide,
  });

  factory Item.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    return Item(
      id: data['id'],
      menuId: data['menuId'],
      name: data['name'],
      description: data['description'],
      price: data['price'],
      isExtra: data['isExtra'],
      isSide: data['isSide'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'menuId': menuId,
      'name': name,
      'description': description,
      'price': price,
      'isExtra': isExtra,
      'isSide': isSide,
    };
  }

  @override
  String toString() {
    return 'id: $id, menuId: $menuId, name: $name, description: $description, price: $price, isExtra: $isExtra, isSide: $isSide';
  }

}
