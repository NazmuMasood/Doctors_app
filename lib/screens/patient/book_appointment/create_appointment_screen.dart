import 'package:doctors_app/models/appointment.dart';
import 'package:doctors_app/models/patient.dart';
import 'package:doctors_app/services/helper_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:doctors_app/screens/patient/home/home_screen.dart';
import 'package:menu_button/menu_button.dart';

class CreateAppointmentScreen extends StatefulWidget {
  String categoryId;
  String categoryTitle;
  String categoryImageUrl;
  String categoryAddress;
  String categorySpecialities;
  String categoryFee;
  String categoryDegrees;
  CreateAppointmentScreen(
      {@required this.categoryId,
      this.categoryTitle,
      this.categoryAddress,
      this.categoryImageUrl,
      this.categorySpecialities,
      this.categoryDegrees,this.categoryFee});
  @override
  _CreateAppointmentScreenState createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DatabaseReference patientsRef =
      FirebaseDatabase.instance.reference().child("users").child("patients");

  final ageCont = TextEditingController();
  final weigtCont = TextEditingController();
  final bloodgroupCont = TextEditingController();

  Patient patient;
  List<dynamic> keys = [];
  Patient updatePatient;
  bool isLoading = false;
  String pKey = '';
  var selectedAddress;
  var selectedProblem;
  var selectedUser;

  DateTime selectedDate = DateTime.now();
//  CreateAppointmentModel appointment = CreateAppointmentModel();
  List<String> lst = ['Morning', 'Afternoon', 'Evening'];
  int selectedIndex = 0;

  final DatabaseReference appointmentsRef =
      FirebaseDatabase.instance.reference().child('appointments');

  void presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        new Duration(days: 0),
      ),
      lastDate: DateTime.now().add(
        new Duration(days: 7),
      ),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //
      // ),
      backgroundColor: Colors.white,
      body: Container(
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * .08,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Text(
                  'Book Appointment',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 23,
                      height: 1.2,
                      color: Colors.grey[800]),
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Container(
                height: 125,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey[400],
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 5, 5),
                      height: 65,
                      width: 65,
                      child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/doctor.png')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.categoryTitle,
                            style: TextStyle(
                                fontSize: 22.5, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            widget.categorySpecialities,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(widget.categoryDegrees!=null?widget.categoryDegrees:'N/A'),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Icon(Icons.credit_card_rounded,size: 20,),
                              SizedBox(width: 4),
                              Text(widget.categoryFee!=null?widget.categoryFee:'N/A',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700,height: 1.3),
                              ),
                            ],
                          ),
                          // Text(widget.categoryFee!=null?widget.categoryFee:'N/A',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(48, 15, 0, 0),
                child: Text(
                  'Pick a date & time slot',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      letterSpacing: 1.2,color: Colors.black87),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(height: 10, thickness: 1.5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 12, 15, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          onPressed: selectedDate.isBefore(DateTime.now())
                              ? null
                              : () {
                                  setState(() {
                                    selectedDate = selectedDate
                                        .subtract(Duration(days: 1));
                                  });
                                },
                          icon: Icon(Icons.arrow_back),
                        ),
                        FlatButton.icon(
                          onPressed: presentDatePicker,
                          icon: Icon(Icons.date_range),
                          label: Text(
                            DateFormat('E, dd MMMM').format(selectedDate),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 19),
                          ),
                        ),
                        IconButton(
                          onPressed: selectedDate.isAfter(DateTime.now().add(
                            new Duration(days: 9),
                          ))
                              ? null
                              : () {
                                  setState(() {
                                    selectedDate =
                                        selectedDate.add(Duration(days: 1));
//                            appointment.date = selectedDate.toString();
                                  });
                                },
                          icon: Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(40, 5, 0, 0),
                  //   child: Text(
                  //     'Pick a time slot',
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.w700,
                  //         fontSize: 17,
                  //         letterSpacing: 1.2),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 0,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        // RaisedButton(
                        //   onPressed: _pushOn,
                        //   child: Text('Book',style: TextStyle(color: Colors.white,letterSpacing: 3.5,fontWeight: FontWeight.w800),),
                        //   color: Colors.teal[400],
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(5),
                        //   ),
                        // ),
                        customRadio(lst[0], 0),
                        customRadio(lst[1], 1),
                        customRadio(lst[2], 2),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height*.012),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 20),
                child: dropDownUser(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 20),
                child: dropDownAddress(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 20),
                child: dropDownProblem(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 20),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400])),
                  height: 100,
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: TextField(
                      strutStyle: StrutStyle.fromTextStyle(TextStyle()),
                        maxLength: 200,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 4,
                        autocorrect: false,
                        decoration: InputDecoration.collapsed(
                            hintText: 'Problem (optional)',
                            hintStyle: TextStyle(color: Colors.teal[300],fontSize: 18))),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 60,
              // ),
              SizedBox(height: MediaQuery.of(context).size.height*.025),
              // Flexible(
              //   child: FractionallySizedBox(
              //     heightFactor: 0.1,
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 35, 0),
                    child: Container(
                      height: 86,
                      width: 76,
                      child: FloatingActionButton(
                        elevation: 4,
                        onPressed: () {
                          checkIfProfileUpdated();
                        },
                        child: Icon(
                          Icons.check,
                          size: 42,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
      print(selectedIndex);
    });
  }

  Widget customRadio(String txt, int index) {
    return RaisedButton(
      onPressed: () {
        changeIndex(index);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.white,
//      borderSide: BorderSide(color: selectedIndex == index ? Colors.teal : Colors.grey),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          txt,
          style: TextStyle(
              color: selectedIndex == index ? Colors.teal : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 15),
        ),
      ),
    );
  }




  Widget dropDownUser() {
    return MenuButton(
      child: dropDownUserButton(), // Widget displayed as the button
      items: ['Myself', 'Mother', '+Add User'], //TODO: Sorted Problems
      dontShowTheSameItemSelected: false,
      topDivider: true,
      popupHeight:
      180, // This popupHeight is optional. The default height is the size of items
      scrollPhysics:
      AlwaysScrollableScrollPhysics(), // Change the physics of opened menu (example: you can remove or add scroll to menu)
      itemBuilder: (value) => Container(
          width: 93,
          height: 55,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            value != null ? value : 'Appointment for',
            style: TextStyle(fontSize: 18),
          )), // Widget displayed for each item
      toggledChild: Container(
        color: Colors.white,
        child: dropDownUserButton(), // Widget displayed as the button,
      ),
      divider: Container(
        height: 1,
        color: Colors.grey,
      ),
      onItemSelected: (value) {
        setState(() {
          selectedUser = value;
        });
        // Action when new item is selected
      },
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
          borderRadius: const BorderRadius.all(Radius.circular(3.0)),
          color: Colors.white),
      onMenuButtonToggle: (isToggle) {
        print(isToggle);
      },
    );
  }

  Widget dropDownUserButton() {
    return SizedBox(
      width: 400,
      height: 45,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                selectedUser != null ? selectedUser : 'Appointment for',
                style: TextStyle(color: Colors.teal[400], fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
                width: 14,
                height: 19,
                child: FittedBox(
                    fit: BoxFit.fill,
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey,
                      size: 13,
                    ))),
          ],
        ),
      ),
    );
  }





  Widget dropDownAddress() {
    return MenuButton(
      child: dropDownAddressButton(), // Widget displayed as the button
      items: [
        'Maternity Hospital',
        'Chittagong Medical',
      ], //TODO: Doctor Chambers
      dontShowTheSameItemSelected: false,
      topDivider: true,
      popupHeight:
          180, // This popupHeight is optional. The default height is the size of items
      scrollPhysics:
          AlwaysScrollableScrollPhysics(), // Change the physics of opened menu (example: you can remove or add scroll to menu)
      itemBuilder: (value) => Container(
          width: 93,
          height: 55,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            value != null ? value : 'Select Chamber',
            style: TextStyle(fontSize: 18),
          )), // Widget displayed for each item
      toggledChild: Container(
        color: Colors.white,
        child: dropDownAddressButton(), // Widget displayed as the button,
      ),
      divider: Container(
        height: 1,
        color: Colors.grey,
      ),
      onItemSelected: (value) {
        setState(() {
          selectedAddress = value;
        });
        // Action when new item is selected
      },
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
          borderRadius: const BorderRadius.all(Radius.circular(3.0)),
          color: Colors.white),
      onMenuButtonToggle: (isToggle) {
        print(isToggle);
      },
    );
  }

  Widget dropDownAddressButton() {
    return SizedBox(
      width: 400,
      height: 45,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                selectedAddress != null ? selectedAddress : 'Select Chamber',
                style: TextStyle(color: Colors.teal[400], fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
                width: 14,
                height: 19,
                child: FittedBox(
                    fit: BoxFit.fill,
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey,
                      size: 13,
                    ))),
          ],
        ),
      ),
    );
  }

  Widget dropDownProblem() {
    return MenuButton(
      child: dropDownProblemButton(),// Widget displayed as the button
      items: [
        'Pelvic Pain',
        'Menstrual Disorder',
        'Urinary Incontinence',
        'Cramp',
        'Other'
      ], //TODO: Sorted Problems
      dontShowTheSameItemSelected: false,
      topDivider: true,
      popupHeight:
          200, // This popupHeight is optional. The default height is the size of items
      scrollPhysics:
          AlwaysScrollableScrollPhysics(), // Change the physics of opened menu (example: you can remove or add scroll to menu)
      itemBuilder: (value) => Container(
          width: 93,
          height: 55,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            value != null ? value : 'Select Problem',
            style: TextStyle(fontSize: 18),
          )), // Widget displayed for each item
      toggledChild: Container(
        color: Colors.white,
        child: dropDownProblemButton(), // Widget displayed as the button,
      ),
      divider: Container(
        height: 1,
        color: Colors.grey,
      ),
      onItemSelected: (value) {
        setState(() {
          selectedProblem = value;
        });
        // Action when new item is selected
      },
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
          borderRadius: const BorderRadius.all(Radius.circular(3.0)),
          color: Colors.white),
      onMenuButtonToggle: (isToggle) {
        print(isToggle);
      },
    );
  }

  Widget dropDownProblemButton() {
    return SizedBox(
      width: 400,
      height: 45,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                selectedProblem != null ? selectedProblem : 'Select Problem',
                style: TextStyle(color: Colors.teal[400], fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
                width: 14,
                height: 19,
                child: FittedBox(
                    fit: BoxFit.fill,
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey,
                      size: 13,
                    ))),
          ],
        ),
      ),
    );
  }


  Future<void> checkIfProfileUpdated() async {
    User user = FirebaseAuth.instance.currentUser;

    DatabaseReference patientsRef =
        FirebaseDatabase.instance.reference().child("users").child('patients');
    patientsRef
        .orderByChild('email')
        .equalTo(user.email)
        .once()
        .then((DataSnapshot snap) {
      Map values = snap.value;
      print('profile view: values- ' + values.toString());
      values.forEach((key, value) {
        if (value['age'] != null &&
            value['weight'] != null &&
            value['bloodgroup'] != null) {
          _pushOn();
        } else {
          showModelBottomSheet(value: value, pKey: key);
        }
      });
    });
  }

  void showModelBottomSheet({var value, String pKey}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (value['age'] == null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Age'),
                        controller: ageCont,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Please Input Age';
                          }
                          return null;
                        },
                        onSaved: (input) => ageCont.text = input.trim(),
                      ),
                    ),
                  if (value['weight'] == null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Weight'),
                        controller: weigtCont,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Please Input Weight';
                          }
                          return null;
                        },
                        onSaved: (input) => weigtCont.text = input.trim(),
                      ),
                    ),
                  if (value['bloodgroup'] == null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'BloodGroup'),
                        controller: bloodgroupCont,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Please Input BloodGroup';
                          }
                          return null;
                        },
                        onSaved: (input) => bloodgroupCont.text = input.trim(),
                      ),
                    ),
                  SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FlatButton(
                        height: 30,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        onPressed: () =>
                            updateProfile(value: value, pKey: pKey),
                        color: Colors.teal,
                        child: Container(
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> updateProfile({var value, String pKey}) async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        if (value['age'] == null) {
          await patientsRef.child(pKey).child('age').set(ageCont.text);
        }
        if (value['weight'] == null) {
          await patientsRef.child(pKey).child('weight').set(weigtCont.text);
        }
        if (value['bloodgroup'] == null) {
          await patientsRef
              .child(pKey)
              .child('bloodgroup')
              .set(bloodgroupCont.text);
        }
        Fluttertoast.showToast(
            msg: 'Profile Updated',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);
        Navigator.of(context).pop();
      } catch (e) {
        print(e.message);
        Fluttertoast.showToast(
            msg: 'Update Unsuccessful',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    }
  }

  Future<void> _pushOn() async {
    try {
      User user = FirebaseAuth.instance.currentUser;

      String apptId = appointmentsRef.push().key;

      Appointment appointment = Appointment(
          pId: user.email,
          dId: widget.categoryId,
          timeSlot: selectedIndex.toString(),
          date: selectedDate.toString().split(' ')[0],
          createdAt: DateTime.now().millisecondsSinceEpoch,
          flag: 'pending',
          dHelper: widget.categoryId +
              '_' +
              selectedDate.toString().split(' ')[0] +
              '_' +
              selectedIndex.toString(),
          pHelper: user.email + '_' + 'pending',
          dHelperFull: widget.categoryId +
              '_' +
              selectedDate.toString().split(' ')[0] +
              '_' +
              selectedIndex.toString() +
              '_' +
              'pending',
          apptId: apptId,
          calDHelper: widget.categoryId +
              '_' +
              selectedDate.toString().split(' ')[0].substring(0, 7),
          calPHelper: user.email +
              '_' +
              selectedDate.toString().split(' ')[0].substring(0, 7));

      await appointmentsRef.child(apptId).set(appointment.toMap());
      HelperClass.showToast('Appointment booking successful');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
          (Route<dynamic> route) => false);
    } catch (e) {
      print(e.message);
      HelperClass.showToast('Appointment booking error. Please try again...');
    }
  }
}

/*class AppointmentModel {
  String patientId;
  String doctorId;
  String date;
  String time;

  AppointmentModel(this.patientId, this.doctorId, this.time, this.date);
}*/
