class UserDetails {
  final String userName;
  final String userAddress;
  final String userLocation;
  final String userRole;

  UserDetails({
    this.userName,
    this.userAddress,
    this.userLocation,
    this.userRole = 'none',
  });

  factory UserDetails.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String userName = data['userName'];
    if (userName == null) {
      return null;
    }
    return UserDetails(
        userName: data['userName'],
        userAddress: data['userAddress'],
        userLocation: data['userLocation'],
        userRole: data['userRole']);
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userAddress': userAddress,
      'userLocation': userLocation,
      'userRole': userRole
    };
  }
}
