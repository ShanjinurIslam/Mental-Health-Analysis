import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mentalheathprediction/models/response.dart';
import 'package:mentalheathprediction/scopedModel/model.dart';
import 'package:mentalheathprediction/static.dart';
import 'package:scoped_model/scoped_model.dart';

import '../utills.dart';

class Reports extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReportState();
  }
}

class ReportState extends State<Reports> {
  Future<List<Response>> getResponses(BuildContext context) async {
    final http.Response response = await http.get(
      GET_RESPONSES,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + ScopedModel.of<MyModel>(context).user.token
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonArray = jsonDecode(response.body);
      List<Response> responses = new List<Response>();
      for (int i = 0; i < jsonArray.length; i++) {
        Map<String, dynamic> json = jsonArray[i];
        responses.add(Response.fromJSON(json));
      }
      return responses;
    } else {
      List<Response> responses = new List<Response>();
      return responses;
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
                      'Responses',
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
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 250,
                          margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                          //height: 150,
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    capitalizeString(snapshot
                                        .data[snapshot.data.length-index-1].problem
                                        .toString()),
                                    style: TextStyle(fontSize: 26),
                                  ),
                                  Spacer(),
                                  Text(
                                    'Catagory',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    snapshot.data[snapshot.data.length-index-1].catagory,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.orange),
                                  ),
                                  Spacer(),
                                  Text(
                                    'Submitted At',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    snapshot.data[snapshot.data.length-index-1].submittedAt,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data.length,
                    );
                  } else {
                    return Container();
                  }
                },
                future: getResponses(context)),
            flex: 6,
          ),
        ],
      ),
    );
  }
}
