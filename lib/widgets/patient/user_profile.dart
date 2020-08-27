import 'package:doctors_app/models/patient.dart';
import 'package:doctors_app/screens/doctor/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class UserofProfile extends StatefulWidget {
  const UserofProfile({Key key, @required this.user})
      : super(key: key);
  final FirebaseUser user;
  @override
  _UserofProfileState createState() => _UserofProfileState();
}

class _UserofProfileState extends State<UserofProfile> {
// List<dynamic> user = [];
  Patient patient ;

  List<dynamic> keys = [];
  List<dynamic> lists = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _textController = new TextEditingController();

  DatabaseReference userInfoRef =
      FirebaseDatabase.instance.reference().child("users").child("patients");

 @override
  Widget build(BuildContext context) {
      return new Scaffold(
        resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Column(
              
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                   
                      padding: EdgeInsets.fromLTRB(25.0, 50.0, 0.0, 0.0),
                      
                      child: Text(
                        'Profile',
                        style: TextStyle(
                            fontSize: 50.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(170.0, 21.0, 0.0, 0.0),
                      child: Text(
                        '.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    )
                  ],
                ),
              ),
                Container(
                padding: EdgeInsets.only(top: 0.0, left: 30.0, right: 30.0),
                   decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                   Radius.circular(25.0),
                   ),
                     color: Colors.white38,
                  border: Border.all(
                    
                    color: Colors.greenAccent,
                    width: 2,
                  )),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                        //(input)=>patient.name,
                          onSaved: (input) =>  input=patient.name,
                          decoration: InputDecoration(
                              labelText: 'NAME',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              // hintText: 'EMAIL',
                              // hintStyle: ,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                        ),
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please type an email';
                            }
                            return null;
                          },
                         onSaved: (input) =>  input=patient.email,
                          decoration: InputDecoration(
                              labelText: 'EMAIL ',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please type your degree';
                            }
                            return null;
                          },
                         // onSaved: (input) => signupModel.degree = input.trim(),
                          decoration: InputDecoration(
                              labelText: 'WEIGHT ',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please type category';
                            }
                            return null;
                          },
                         onSaved: (input) =>input=patient.age,
                          decoration: InputDecoration(
                              labelText: 'AGE ',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                        ),
                     
                      
                        SizedBox(height: 10.0),
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please type address';
                            }
                            return null;
                          },
                         onSaved: (input) => input=patient.bloodgroup,
                          decoration: InputDecoration(
                              labelText: 'BLOOD GROUP ',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                        ),
                        SizedBox(height: 10.0),          
                       Container(
                                height: 50.0,
                                child: RaisedButton(
                                 // onPressed: userInfoFutureBuilder ,
                                  color: Colors.green,
                                  splashColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Center(
                                    child: Text(
                                      'UPDATE',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                ),
                              ),
                      /*       Center(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ),
                              ),
                              */
                        SizedBox(height: 30.0),
                        
                        
                      ],
                    )),
              ),  
           
            /* Expanded(child: readInfo(),
             )*/

             
             ]

            ),
            ),
            );
  }
     /*        
Widget readInfo(){
  userInfoRef
  .equalTo(widget.user.email).once().then((DataSnapshot snapshot) {
    print('Data : ${snapshot.value}');
  });
}
*/

/*
Widget userInfoFutureBuilder(){
     return RefreshIndicator(
      onRefresh: refresh,
      child: FutureBuilder(
          future: userInfoRef
              .equalTo(widget.user.email)
              .once(),
          builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
            if (snapshot.hasData) {
              lists.clear();
              keys.clear();
              Map<dynamic, dynamic> values = snapshot.data.value;
              print('Downloaded snapshot -> ' + snapshot.data.value.toString());
              if (values == null) {
                return SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Center(child: Text('No results found')),
                    height: MediaQuery.of(context).size.height - 165,
                  ),
                );
              }
              values.forEach((key, values) {
                keys.add(key);
               lists.add(values);
              });
              return new ListView.builder(
                padding: EdgeInsets.all(2),
                shrinkWrap: true,
                itemCount: lists.length,
                itemBuilder: (_, index) {
                  return userUI(
                      lists[index]["name"],
                      lists[index]["email"],
                     // lists[index]["age"],
                     // lists[index]["email"],
                      );
                });
            }
            return Center(child: CircularProgressIndicator());
          }),
    );

      }

*/

Widget userUI(String address, String category) {
    return Container(
      padding: EdgeInsets.fromLTRB(21, 0, 21, 0),
      height: 165,
      child: Column(
        children: <Widget>[
          Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Container(
                height: 146,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(10),
                          height: 60,
                          width: 60,
                          child: CircleAvatar(
                            child: Image(
                              image: AssetImage('assets/images/doctor.png'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 14, 8, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                lists[0],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                               lists[1],
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                address,
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Expanded(

                      child:Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child:
                                  Container(
                                    padding: EdgeInsets.fromLTRB(5, 0, 10, 4),
                                    width: 150,
                                    height: 35,
                                    child: RaisedButton(
                                      onPressed: () {
                                        
                                      },
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          side: BorderSide(
                                              color:
                                              Color.fromRGBO(28, 222, 187, 1))),
                                      child: Text(
                                        'View Profile',
                                        style: TextStyle(
                                          color: Colors.teal[600],
                                        ),
                                      ),
                                    ),
                                  ),),
                                Container(
                                  height: 35,
                                  width: 185,
                                  padding: EdgeInsets.fromLTRB(3, 0, 0, 5),
                                  child: RaisedButton(
                                    onPressed: () {
                                     
                                    },
                                    color: Colors.teal[400],
                                    //Color.fromRGBO(28, 222, 187, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Book Appointment',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Future<void> getUser() async {
     
 await userInfoRef
  .equalTo(widget.user.email).once().then((DataSnapshot snapshot) {
  
    print('Data : ${snapshot.value}');
    Patient patient= Patient.fromMap(snapshot.value);
    setState(() {
      this.patient=patient;
    });
  
  }); 
  } 

Future<void> refresh() async {
    setState(() {
      //appointments = [];
      keys = [];
    });
  }

 @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
   // _searchedDocController.dispose();
    super.dispose();
  }

 @override
  void initState() {
    getUser();
    super.initState();
  }
}