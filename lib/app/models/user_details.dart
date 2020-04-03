const String ROLE_NONE = 'None';
const String ROLE_MANAGER = 'Manager';
const String ROLE_STAFF = 'Staff';
const String ROLE_PATRON = 'Patron';
const String ROLE_DEV = 'Dev';

class UserDetails {
  String name;
  String address;
  String nearestRestaurantId;
  String role;
  String deviceName;

  UserDetails({
    this.name = '',
    this.address = '',
    this.nearestRestaurantId = '',
    this.role = ROLE_NONE,
    this.deviceName = ''
  });

  factory UserDetails.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return UserDetails();
    }
    return UserDetails(
        name: data['name'],
        address: data['address'],
        nearestRestaurantId: data['nearestRestaurantId'],
        role: data['role'],
        deviceName: data['deviceName']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'nearestRestaurantId': nearestRestaurantId,
      'role': role,
      'deviceName': deviceName
    };
  }
}
