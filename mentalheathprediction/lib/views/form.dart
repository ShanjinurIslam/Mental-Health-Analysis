import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:mentalheathprediction/models/problem.dart';
import 'package:mentalheathprediction/models/question.dart';
import 'package:http/http.dart' as http;
import 'package:mentalheathprediction/models/response.dart';
import 'package:mentalheathprediction/scopedModel/model.dart';
import 'package:mentalheathprediction/static.dart';
import 'package:mentalheathprediction/utills.dart';
import 'package:scoped_model/scoped_model.dart';

class FormView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormState();
  }
}

class FormState extends State<FormView> {
  List<Question> questions = new List<Question>();
  bool isLoading = true;
  bool isSubmitted = false;

  void getQuestions(BuildContext context, String problemId) async {
    final http.Response response = await http.get(
      QUESTION_URL + problemId,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + ScopedModel.of<MyModel>(context).user.token
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonArray = jsonDecode(response.body)['questions'];

      for (int i = 0; i < jsonArray.length; i++) {
        questions.add(Question.fromJSON(jsonArray[i]));
      }
      setState(() {
        isLoading = false;
      });
    } else {
      //
    }
  }

  void postResponse(
      BuildContext context, String problemId, int rawScore) async {
    final http.Response response = await http.post(
      POST_RESPONSE + problemId,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + ScopedModel.of<MyModel>(context).user.token
      },
      body: jsonEncode(<String, int>{'rawScore': rawScore}),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      print(json);
      Response res = Response(
          id: json['_id'],
          problem: json['problem']['name'],
          catagory: json['catagory'],
          submittedAt: json['submittedAt']);
      Navigator.pushReplacementNamed(context, '/response', arguments: res);
    } else {
      //
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Problem problem = ModalRoute.of(context).settings.arguments;
    if (isLoading) {
      getQuestions(context, problem.id);
      ScopedModel.of<MyModel>(context).initCheckArr();
    }

    return Scaffold(
        body: SafeArea(
      bottom: false,
      child: (isLoading | isSubmitted)
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : Column(
              children: <Widget>[
                Flexible(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(40, 10, 40, 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            capitalizeString(problem.name),
                            style: TextStyle(fontSize: 32),
                          ),
                        ],
                      ),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                    flex: 6,
                    child: ListView.builder(
                      //physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(40, 10, 0, 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                questions[index].engQuestion,
                                style: TextStyle(fontSize: 24),
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                              CheckboxGroup(
                                onSelected: (List selected) => setState(() {
                                  ScopedModel.of<MyModel>(context)
                                      .setCheckArr(index, selected);
                                }),
                                checked: ScopedModel.of<MyModel>(context)
                                    .checkedArr[index],
                                labels: <String>[
                                  "Never",
                                  "Rarely",
                                  "Sometimes",
                                  "Often",
                                  "Always"
                                ],
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                            ],
                          ),
                        );
                      },
                      itemCount: questions.length,
                    )),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
                    child: RaisedButton(
                      color: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      onPressed: () {
                        int size = questions.length;
                        int rawScore = ScopedModel.of<MyModel>(context)
                            .calculateRawScore(size);
                        setState(() {
                          isSubmitted = true;
                        });
                        postResponse(context, problem.id, rawScore);
                      },
                      child: Container(
                        height: 48,
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    ));
  }
}
