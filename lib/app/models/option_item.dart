class OptionItem {
  final String id;
  final String optionId;
  final String name;

  OptionItem({
    this.id,
    this.optionId,
    this.name,
  });

  factory OptionItem.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    return OptionItem(
      id: data['id'],
      optionId: data['optionId'],
      name: data['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'optionId': optionId,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'id: $id, menuId: $optionId, name: $name';
  }

}
