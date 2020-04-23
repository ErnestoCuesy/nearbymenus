class Menu {
  final String id;
  final String restaurantId;
  final String name;

  Menu({this.id, this.restaurantId, this.name});

  factory Menu.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    return Menu(
      id: data['id'],
      restaurantId: data['restaurantId'],
      name: data['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'id: $id, restaurantId: $restaurantId, name: $name';
  }

}