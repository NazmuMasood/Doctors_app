class RunningSlot{
  String currentSerial;
  List missingSerials;
  String dHelper;
  String slotState;
  String dId;

  RunningSlot({this.currentSerial, this.missingSerials, this.dHelper, this.slotState, this.dId});

  Map<String, dynamic> toMap() {
    return {
      'currentSerial': currentSerial,
      'missingSerials': missingSerials,
      'dHelper': dHelper,
      'slotState': slotState,
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
        slotState: map['slotState '],
        dId: map['dId']
    );
  }
}