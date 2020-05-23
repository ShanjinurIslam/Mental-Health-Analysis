import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mentalheathprediction/models/problem.dart';
import 'package:mentalheathprediction/scopedModel/model.dart';
import 'package:mentalheathprediction/static.dart';
import 'package:mentalheathprediction/utills.dart';
import 'package:scoped_model/scoped_model.dart';

class Problems extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProblemState();
  }
}

class ProblemState extends State<Problems> {
  Future<List<Problem>> getProblems(BuildContext context) async {
    final http.Response response = await http.get(
      PROBLEM_URL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + ScopedModel.of<MyModel>(context).user.token
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonArray = jsonDecode(response.body)['problems'];
      List<Problem> problems = new List<Problem>();
      for (int i = 0; i < jsonArray.length; i++) {
        Map<String, dynamic> json = jsonArray[i];
        problems.add(Problem.fromJSON(json));
      }
      return problems;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      'Problems',
                      style: TextStyle(fontSize: 32),
                    )
                  ],
                ),
              ),
            ),
            flex: 1,
          ),
          Flexible(
            child: FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CupertinoActivityIndicator();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: EdgeInsets.all(40),
                            child: RaisedButton(
                              color: Colors.white,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              onPressed: () {
                                print(snapshot.data[index].id);
                                Navigator.pushNamed(context, '/form',
                                    arguments: snapshot.data[index]);
                              },
                              child: Container(
                                height: 400,
                                child: Padding(
                                  padding: EdgeInsets.all(40),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Image.asset(
                                        'images/' +
                                            snapshot.data[index].name +
                                            '.png',
                                      ),
                                      Spacer(),
                                      Text(
                                        capitalizeString(snapshot
                                            .data[index].name
                                            .toString()),
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      },
                      itemCount: snapshot.data.length,
                    );
                  } else {
                    return Container();
                  }
                },
                future: getProblems(context)),
            flex: 6,
          ),
        ],
      ),
    );
  }
}
