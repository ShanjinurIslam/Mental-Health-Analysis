import 'package:flutter/material.dart';
import 'package:mentalheathprediction/routes.dart';
import 'package:mentalheathprediction/scopedModel/model.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp(
      model: MyModel(),
    ));

class MyApp extends StatelessWidget {
  final MyModel model;

  const MyApp({Key key, @required this.model}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MyModel>(
        model: model,
        child: MaterialApp(
            title: 'Mental Problem Analysis',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            routes: routes));
  }
}
