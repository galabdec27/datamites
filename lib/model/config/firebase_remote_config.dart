class FirebaseRemoteConfig {
  late String _serverAddress;
  late String _authUrl ;
  late String _baseUrl ;
  late String _cashCredit ;
  late String _courseCredit ;
  late String _forceUpdate ;
  late String _iosVersion;
  late String _androidVersion;
  late String _playstoreUrl;
  late String _appstoreUrl;
  late String _privacyPolicy;
  late String _telephone;
  late String _termsOfServices;
  late String _updateReason;

  String get serverAddress => _serverAddress;

  set serverAddress(String value) {
    _serverAddress = value;
  }

  String get authUrl => _authUrl;

  String get updateReason => _updateReason;

  set updateReason(String value) {
    _updateReason = value;
  }

  String get termsOfServices => _termsOfServices;

  set termsOfServices(String value) {
    _termsOfServices = value;
  }

  String get telephone => _telephone;

  set telephone(String value) {
    _telephone = value;
  }

  String get privacyPolicy => _privacyPolicy;

  set privacyPolicy(String value) {
    _privacyPolicy = value;
  }

  String get appstoreUrl => _appstoreUrl;

  set appstoreUrl(String value) {
    _appstoreUrl = value;
  }

  String get playstoreUrl => _playstoreUrl;

  set playstoreUrl(String value) {
    _playstoreUrl = value;
  }

  String get androidVersion => _androidVersion;

  set androidVersion(String value) {
    _androidVersion = value;
  }

  String get iosVersion => _iosVersion;

  set iosVersion(String value) {
    _iosVersion = value;
  }

  String get forceUpdate => _forceUpdate;

  set forceUpdate(String value) {
    _forceUpdate = value;
  }

  String get courseCredit => _courseCredit;

  set courseCredit(String value) {
    _courseCredit = value;
  }

  String get cashCredit => _cashCredit;

  set cashCredit(String value) {
    _cashCredit = value;
  }

  String get baseUrl => _baseUrl;

  set baseUrl(String value) {
    _baseUrl = value;
  }

  set authUrl(String value) {
    _authUrl = value;
  }
}