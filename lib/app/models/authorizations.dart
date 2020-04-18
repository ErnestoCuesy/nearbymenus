class Authorizations {
  final Map<String, dynamic> authorizedRoles;
  final Map<String, dynamic> authorizedNames;

  Authorizations({this.authorizedRoles, this.authorizedNames});

  factory Authorizations.fromMap(Map<dynamic, dynamic> value, String documentId) {
    if (value == null) {
      return null;
    }
    return Authorizations(
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