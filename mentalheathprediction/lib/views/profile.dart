import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentalheathprediction/models/user.dart';
import 'package:mentalheathprediction/scopedModel/model.dart';
import 'package:mentalheathprediction/static.dart';
import 'package:mentalheathprediction/views/sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import '../utills.dart';

class Profile extends StatelessWidget {
  void logOut(BuildContext context) async {
    final http.Response response = await http.post(
      LOGOUT_URL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + ScopedModel.of<MyModel>(context).user.token
      },
    );
    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacement(new PageRouteBuilder(
          pageBuilder: (BuildContext context, _, __) {
        return new SignInView();
      }, transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
        return new FadeTransition(opacity: animation, child: child);
      }));
    } else {
      //do nothing
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = ScopedModel.of<MyModel>(context).user;
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          Flexible(
            child: Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(40, 10, 40, 40),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Profile',
                      style: TextStyle(fontSize: 32),
                    )
                  ],
                ),
              ),
            ),
            flex: 1,
          ),
          Flexible(
            child: Column(
              children: <Widget>[
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  //height: 150,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                CupertinoIcons.person,
                                size: 120,
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          Spacer(),
                          Text(
                            capitalizeString(user.username.toString()),
                            style: TextStyle(fontSize: 24),
                          ),
                          Text(user.email),
                          Text(user.gender),
                          Text(user.age.toString()),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
                  child: RaisedButton(
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    onPressed: () {
                      logOut(context);
                    },
                    child: Container(
                      height: 48,
                      child: Center(
                        child: Text(
                          'Log Out',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            flex: 6,
          )
        ],
      ),
    );
  }
}
