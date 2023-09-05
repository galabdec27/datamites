class UserModel {
  late String userName;
  late String userEmail;
  late String userImage;
  late String jwtKey;
  late String refreshKey;
  late String userId;
  late String userDob;
  late String userPhone;

  set setUserName(String userName) => this.userName = userName;

  String get getUserName => userName;

  set setUserEmail(String userEmail) => this.userEmail = userEmail;

  String get getUserEmail => userEmail;

  set setUserImage(String userImage) => this.userImage = userImage;

  String get getUserImage => userImage;

  set setJwtKey(String jwtKey) => this.jwtKey = jwtKey;

  String get getJwtKey => jwtKey;

  set setUserId(String userId) => this.userId = userId;

  String get getUserId => userId;

  set setUserDob(String userDob) => this.userDob = userDob;

  String get getUserDob => userDob;

  set setUserPhone(String userPhone) => this.userPhone = userPhone;

  String get getUserPhone => userPhone;

  set setRefreshKey(String refreshKey) => this.refreshKey = refreshKey;

  String get getRefreshKey => refreshKey;
}
