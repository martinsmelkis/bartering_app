class LocationCheckInService {
  static final LocationCheckInService _instance = LocationCheckInService._internal();
  factory LocationCheckInService() => _instance;
  LocationCheckInService._internal();

  bool _isCheckedIn = false;

  bool get isCheckedIn => _isCheckedIn;

  void setCheckedIn(bool value) {
    _isCheckedIn = value;
  }
}
