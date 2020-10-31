class Patient {
  String email;
  String name;
  String age;
  String bloodgroup;
  String weight;
  String fcmToken;
  String uId;

  Patient({this.email, this.name, this.age, this.bloodgroup, this.weight, this.fcmToken, this.uId});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'age': age,
      'bloodgroup': bloodgroup,
      'weight': weight,
      'fcmToken' : fcmToken,
      'uId': uId
    };
  }

  static Patient fromMap(Map<dynamic, dynamic> map) {
    if (map == null) {
      return null;
    }
    return Patient(
        email: map['email'],
        name: map['name'],
        age: map['age'],
        bloodgroup: map['bloodgroup'],
        weight: map['weight'],
        fcmToken: map['fcmToken'],
        uId: map['uId']
    );
  }

 /* toJson(){
    return{
      'email': email,
      'name': name,
      'age': age,
      'bloodgroup': bloodgroup,
      'weight': weight
    };
  }*/
}
