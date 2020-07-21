class ItemImage {
  final String id;
  String description;
  String url;

  ItemImage({this.id, this.description, this.url});

  factory ItemImage.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    return ItemImage(
      id: data['id'],
      description: data['description'],
      url: data['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'url': url,
    };
  }

  @override
  String toString() {
    return 'id: $id, description: $description, url: $url';
  }
}