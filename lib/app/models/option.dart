class Option {
  final String id;
  final String restaurantId;
  final String name;
  final int numberAllowed;

  Option({
    this.id,
    this.restaurantId,
    this.name,
    this.numberAllowed,
  });

  factory Option.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    return Option(
      id: data['id'],
      restaurantId: data['restaurantId'],
      name: data['name'],
      numberAllowed: data['numberAllowed'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'name': name,
      'numberAllowed': numberAllowed,
    };
  }

  @override
  String toString() {
    return 'id: $id, restaurantId: $restaurantId, name: $name, numberAllowed: $numberAllowed';
  }
}
