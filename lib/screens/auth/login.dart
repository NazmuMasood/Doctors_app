import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../patient/home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              TextFormField(
                // ignore: missing_return
                validator: (input) {
                  if(input.isEmpty){
                    return 'Please type an email';
                  }
                },
                onSaved: (input) => _email = input,
                decoration: InputDecoration(
                  labelText: 'Email'
                ),
              ),
              TextFormField(
                // ignore: missing_return
                validator: (input) {
                  if(input.isEmpty){
                    return 'Please provide a password';
                  }
                  if(input.length<6){
                    return 'Your password needs to be at-least 6 characters';
                  }
                },
                onSaved: (input) => _password = input,
                decoration: InputDecoration(
                    labelText: 'Password'
                ),
                obscureText: true,
              ),
              RaisedButton(
                  onPressed: login,
                  child: Text('Login'),
              )
            ],
        )
      ),
    );
  }

  Future<void> login() async{
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance.
              signInWithEmailAndPassword(email: _email, password: _password)).user;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(user: user) ));
      }
      catch(e){ print(e.message);}
    }
  }
}
