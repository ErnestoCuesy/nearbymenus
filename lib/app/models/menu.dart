class Menu {
  final String id;
  final String restaurantId;
  final String name;
  final String notes;

  Menu({this.id, this.restaurantId, this.name, this.notes});

  factory Menu.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    return Menu(
      id: data['id'],
      restaurantId: data['restaurantId'],
      name: data['name'],
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'name': name,
      'notes': notes,
    };
  }

  @override
  String toString() {
    return 'id: $id, restaurantId: $restaurantId, name: $name, notes: $notes';
  }

}