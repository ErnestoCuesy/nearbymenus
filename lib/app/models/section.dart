class Section {
  final String id;
  final String menuId;
  final String name;
  final String notes;
  final bool hidden;
  final bool onlyForExtras;
  final bool onlyForSides;

  Section(
      {this.id,
      this.menuId,
      this.name,
      this.notes,
      this.hidden,
      this.onlyForExtras,
      this.onlyForSides,
  });

  factory Section.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    return Section(
      id: data['id'],
      menuId: data['menuId'],
      name: data['name'],
      notes: data['notes'],
      hidden: data['hidden'],
      onlyForExtras: data['onlyForExtras'],
      onlyForSides: data['onlyForSides'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'menuId': menuId,
      'name': name,
      'notes': notes,
      'hidden': hidden,
      'onlyForExtras': onlyForExtras,
      'onlyForSides': onlyForSides,
    };
  }

  @override
  String toString() {
    return 'id: $id, menuId: $menuId, name: $name, notes: $notes, hidden: $hidden, onlyForExtras: $onlyForExtras, onlyForSides: $onlyForSides,';
  }
}
