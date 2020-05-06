class MenuItem {
  final String id;
  final String menuId;
  final String name;
  final String description;
  final double price;
  final List<String> options;
  final bool isExtra;
  final bool isSide;

  MenuItem({
    this.id,
    this.menuId,
    this.name,
    this.description,
    this.price,
    this.options,
    this.isExtra,
    this.isSide,
  });

  factory MenuItem.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    return MenuItem(
      id: data['id'],
      menuId: data['menuId'],
      name: data['name'],
      description: data['description'],
      price: data['price'],
      options: List.from(data['options']) ?? [],
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
      'options': options,
      'isExtra': isExtra,
      'isSide': isSide,
    };
  }

  @override
  String toString() {
    return 'id: $id, menuId: $menuId, name: $name, description: $description, price: $price, options: $options, isExtra: $isExtra, isSide: $isSide';
  }

}
