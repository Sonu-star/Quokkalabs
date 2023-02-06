class CallHistoryModel {
  String? _date;
  String? _simName;
  String? _mobileNumber;
  String? _duration;

  CallHistoryModel(
      {String? date, String? simName, String? mobileNumber, String? duration}) {
    if (date != null) {
      this._date = date;
    }
    if (simName != null) {
      this._simName = simName;
    }
    if (mobileNumber != null) {
      this._mobileNumber = mobileNumber;
    }
    if (duration != null) {
      this._duration = duration;
    }
  }

  String? get date => _date;
  set date(String? date) => _date = date;
  String? get simName => _simName;
  set simName(String? simName) => _simName = simName;
  String? get mobileNumber => _mobileNumber;
  set mobileNumber(String? mobileNumber) => _mobileNumber = mobileNumber;
  String? get duration => _duration;
  set duration(String? duration) => _duration = duration;

  CallHistoryModel.fromJson(Map<String, dynamic> json) {
    _date = json['date'];
    _simName = json['simName'];
    _mobileNumber = json['mobileNumber'];
    _duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this._date;
    data['simName'] = this._simName;
    data['mobileNumber'] = this._mobileNumber;
    data['duration'] = this._duration;
    return data;
  }
}
