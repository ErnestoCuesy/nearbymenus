const String ROLE_NONE = 'None';
const String ROLE_MANAGER = 'Manager';
const String ROLE_STAFF = 'Staff';
const String ROLE_PATRON = 'Patron';
const String ROLE_CHECK_SUBSCRIPTION = 'Subscription';
const String ROLE_DEV = 'Dev';

class UserDetails {
  String email;
  String name;
  String address;
  String nearestRestaurantId;
  String role;
  String deviceName;
  Map<String, dynamic> orderOnHold;

  UserDetails({
    this.email = '',
    this.name = '',
    this.address = '',
    this.nearestRestaurantId = '',
    this.role = ROLE_NONE,
    this.deviceName = '',
    this.orderOnHold,
  });

  factory UserDetails.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return UserDetails();
    }
    return UserDetails(
        email: data['email'],
        name: data['name'],
        address: data['address'],
        nearestRestaurantId: data['nearestRestaurantId'],
        role: data['role'],
        deviceName: data['deviceName'],
        orderOnHold: data['orderOnHold'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'address': address,
      'nearestRestaurantId': nearestRestaurantId,
      'role': role,
      'deviceName': deviceName,
      'orderOnHold': orderOnHold,
    };
  }
}
