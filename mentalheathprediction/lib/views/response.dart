import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentalheathprediction/models/response.dart';
import '../utills.dart';

class ResponseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Response response = ModalRoute.of(context).settings.arguments;
    print(response.submittedAt);
    return Scaffold(
        body: SafeArea(
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
                      'Report',
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
                          Text(
                            capitalizeString(response.problem),
                            style: TextStyle(fontSize: 26),
                          ),
                          Spacer(),
                          Text(
                            'Catagory',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            response.catagory,
                            style:
                                TextStyle(fontSize: 20, color: Colors.orange),
                          ),
                          Spacer(),
                          Text(
                            'Submitted At',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            response.submittedAt,
                            style: TextStyle(color: Colors.grey),
                          ),
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
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 48,
                      child: Center(
                        child: Text(
                          'Back to Home',
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
    ));
  }
}
