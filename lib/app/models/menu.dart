class Menu {
  final String id;
  final String restaurantId;
  final String name;
  final String notes;
  final int sequence;
  final bool hidden;
  final bool onlyForExtras;
  final bool onlyForSides;

  Menu({
    this.id,
    this.restaurantId,
    this.name,
    this.notes,
    this.sequence,
    this.hidden,
    this.onlyForExtras,
    this.onlyForSides,
  });

  factory Menu.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    return Menu(
      id: data['id'],
      restaurantId: data['restaurantId'],
      name: data['name'],
      notes: data['notes'],
      sequence: data['sequence'],
      hidden: data['hidden'],
      onlyForExtras: data['onlyForExtras'],
      onlyForSides: data['onlyForSides'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'name': name,
      'notes': notes,
      'sequence': sequence,
      'hidden': hidden,
      'onlyForExtras': onlyForExtras,
      'onlyForSides': onlyForSides,
    };
  }

  @override
  String toString() {
    return 'id: $id, restaurantId: $restaurantId, name: $name, notes: $notes, sequence: $sequence';
  }
}
