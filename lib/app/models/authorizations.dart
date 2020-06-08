class Authorizations {
  final String id;
  final Map<dynamic, dynamic> authorizedRoles;
  final Map<dynamic, dynamic> authorizedNames;

  Authorizations({this.id, this.authorizedRoles, this.authorizedNames});

  factory Authorizations.fromMap(Map<dynamic, dynamic> value, String documentId) {
    if (value == null) {
      return null;
    }
    return Authorizations(
      id: documentId,
      authorizedRoles: value['authorizedRoles'],
      authorizedNames: value['authorizedNames'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'authorizedRoles': authorizedRoles,
      'authorizedNames': authorizedNames,
    };
  }
}