class RunningSlot{
  int currentSerial;
  List missingSerials;
  String dHelper;
  String currentState;

  RunningSlot({this.currentSerial, this.missingSerials, this.dHelper, this.currentState});

  Map<String, dynamic> toMap() {
    return {
      'currentSerial': currentSerial,
      'missingSerials': missingSerials,
      'dHelper': dHelper,
      'currentState': currentState,
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
        currentState: map['currentState']
    );
  }
}