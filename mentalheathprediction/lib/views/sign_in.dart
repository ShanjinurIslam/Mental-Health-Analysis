import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Icon(Icons.email),
                                flex: 1,
                              ),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: 'example@example.com'),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Icon(Icons.lock),
                                flex: 1,
                              ),
                              Expanded(
                                child: TextField(
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
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
                              borderRadius: BorderRadius.circular(15)),
                          onPressed: () {},
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
                                    style: TextStyle(color: Colors.white),
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
                          Text('Sign Up',style: TextStyle(color: Colors.orange),)
                        ],
                      ),
                    ))),
            flex: 2,
          ),
        ],
      ),
    );
  }
}
