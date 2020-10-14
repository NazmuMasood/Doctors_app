class RunningSlot{
  String currentSerial;
  List missingSerials;
  String dHelper;
  String currentState;
  String dId;

  RunningSlot({this.currentSerial, this.missingSerials, this.dHelper, this.currentState, this.dId});

  Map<String, dynamic> toMap() {
    return {
      'currentSerial': currentSerial,
      'missingSerials': missingSerials,
      'dHelper': dHelper,
      'currentState': currentState,
      'dId': dId
    };
  }

  static RunningSlot fromMap(Map<dynamic, dynamic> map) {
    if (map == null) {
      return null;
    }
    return RunningSlot(
        currentSerial: map['currentSerial'],
        missingSerials: map['missingSerials'],
        dHelper: map['dHelper'],
        currentState: map['currentState'],
        dId: map['dId']
    );
  }
}