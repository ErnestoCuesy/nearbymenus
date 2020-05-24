class UserDetails {
  String email;
  String name;
  String address1;
  String address2;
  String address3;
  String address4;
  Map<String, dynamic> orderOnHold;

  UserDetails({
    this.email = '',
    this.name = '',
    this.address1 = '',
    this.address2 = '',
    this.address3 = '',
    this.address4 = '',
    this.orderOnHold,
  });

  factory UserDetails.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return UserDetails();
    }
    return UserDetails(
        email: data['email'],
        name: data['name'],
        address1: data['address1'],
        address2: data['address2'],
        address3: data['address3'],
        address4: data['address4'],
        orderOnHold: data['orderOnHold'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'address1': address1,
      'address2': address2,
      'address3': address3,
      'address4': address4,
      'orderOnHold': orderOnHold,
    };
  }
}
