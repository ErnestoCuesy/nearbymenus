class Section {
  final String id;
  final String menuId;
  final String name;

  Section({this.id, this.menuId, this.name});

  factory Section.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    return Section(
      id: data['id'],
      menuId: data['menuId'],
      name: data['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'menuId': menuId,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'id: $id, menuId: $menuId, name: $name';
  }

}