import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mentalheathprediction/models/user.dart';
import 'package:mentalheathprediction/scopedModel/model.dart';
import 'package:mentalheathprediction/static.dart';
import 'package:mentalheathprediction/views/home.dart';
import 'package:scoped_model/scoped_model.dart';

class SignInView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignInViewState();
  }
}

class SignInViewState extends State<SignInView> {
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool flag = false;

  void signIn(String email, String password, BuildContext context) async {
    setState(() {
      flag = true;
    });

    final response = await http.post(
      LOGIN_URL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      User user = User.fromJSON(json.decode(response.body));
      ScopedModel.of<MyModel>(context).setUser(user);
      Navigator.of(context).pushReplacement(new PageRouteBuilder(
          pageBuilder: (BuildContext context, _, __) {
        return new Home();
      }, transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
        return new FadeTransition(opacity: animation, child: child);
      }));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // set up the button
      setState(() {
        flag = false;
      });
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Log In"),
        content: Text("Authorization Failed"),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: flag
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        color: Colors.white,
                      ),
                      flex: 2,
                    ),
                    Flexible(
                      child: Container(
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(40, 20, 0, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Login',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 32),
                                    ),
                                    Text(
                                      'Please sign in to continue',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      flex: 1,
                    ),
                    Flexible(
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Flexible(child: Container(), flex: 1),
                                        Flexible(
                                          child: Text('Email'),
                                          flex: 5,
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          child: Icon(Icons.email),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter email';
                                              }
                                              return null;
                                            },
                                            controller: emailController,
                                            keyboardType: TextInputType.text,
                                            decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                hintText:
                                                    'example@example.com'),
                                          ),
                                          flex: 5,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Flexible(child: Container(), flex: 1),
                                        Flexible(
                                          child: Text('Password'),
                                          flex: 5,
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          child: Icon(Icons.lock),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter password';
                                              }
                                              return null;
                                            },
                                            controller: passwordController,
                                            obscureText: true,
                                            keyboardType: TextInputType.text,
                                            decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                hintText: '********'),
                                          ),
                                          flex: 5,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: RaisedButton(
                                    color: Colors.orange,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        signIn(emailController.text,
                                            passwordController.text, context);
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 100,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Text(
                                              'Sign In',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Icon(CupertinoIcons.forward,
                                                color: Colors.white)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      flex: 3,
                    ),
                    Flexible(
                      child: Container(
                          color: Colors.white,
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.all(40),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Don\'t have an account?'),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Sign Up',
                                      style: TextStyle(color: Colors.orange),
                                    )
                                  ],
                                ),
                              ))),
                      flex: 2,
                    ),
                  ],
                ),
        ));
  }
}
