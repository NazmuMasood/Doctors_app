import 'package:flutter/material.dart';

class AppointmentRadioButton extends StatefulWidget {
  Function(int) onSelectedIndex;
  @override
  _AppointmentRadioButtonState createState() => _AppointmentRadioButtonState();
}

class _AppointmentRadioButtonState extends State<AppointmentRadioButton> {

  List<String> lst = ['Morning','Afternoon','Evening'];
   int selectedIndex = 0;



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          customRadio(lst[0],0),
          customRadio(lst[1],1),
          customRadio(lst[2],2),
        ],
      ),
    );
  }

  void changeIndex(int index){
    setState(() {
      selectedIndex = index;
      print(selectedIndex);
    });

  }
  Widget customRadio(String txt,int index){
    return RaisedButton(
      onPressed: () {changeIndex(index);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.white,
//      borderSide: BorderSide(color: selectedIndex == index ? Colors.teal : Colors.grey),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(txt,style: TextStyle(color: selectedIndex == index ?Colors.teal : Colors.grey,fontWeight: FontWeight.bold,fontSize: 15),),
      ),
    );
  }
}
