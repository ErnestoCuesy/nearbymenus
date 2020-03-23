const String ROLE_NONE = 'none';
const String ROLE_ADMIN = 'admin';
const String ROLE_STAFF = 'staff';
const String ROLE_PATRON = 'patron';
const String ROLE_DEV = 'dev';

class UserDetails {
  String name;
  String address;
  String complexName;
  String nearestRestaurant;
  String role;
  String deviceName;

  UserDetails({
    this.name = '',
    this.address = '',
    this.complexName = '',
    this.nearestRestaurant = '',
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
        complexName: data['complexName'],
        nearestRestaurant: data['nearestRestaurant'],
        role: data['role'],
        deviceName: data['deviceName']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'complexName': complexName,
      'nearestRestaurant': nearestRestaurant,
      'role': role,
      'deviceName': deviceName
    };
  }
}
