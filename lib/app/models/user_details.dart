const String ROLE_NONE = 'None';
const String ROLE_MANAGER = 'Manager';
const String ROLE_STAFF = 'Staff';
const String ROLE_PATRON = 'Patron';
const String ROLE_DEV = 'Dev';

class UserDetails {
  String name;
  String address;
  String complexName;
  String nearestRestaurant;
  String managesRestaurant;
  String role;
  String deviceName;

  UserDetails({
    this.name = '',
    this.address = '',
    this.complexName = '',
    this.nearestRestaurant = '',
    this.managesRestaurant,
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
        managesRestaurant: data['managesRestaurant'],
        role: data['role'],
        deviceName: data['deviceName']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'complexName': complexName,
      'nearestRestaurant': nearestRestaurant,
      'managesRestaurant': managesRestaurant,
      'role': role,
      'deviceName': deviceName
    };
  }
}
