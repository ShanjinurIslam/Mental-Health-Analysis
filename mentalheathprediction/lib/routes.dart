import 'package:flutter/material.dart';
import 'package:mentalheathprediction/views/home.dart';
import 'package:mentalheathprediction/views/response.dart';
import 'package:mentalheathprediction/views/sign_in.dart';
import 'package:mentalheathprediction/views/form.dart';

final routes = {
  '/': (BuildContext context) => SignInView(),
  '/home': (BuildContext context) => Home(),
  '/form': (BuildContext context) => FormView(),
  '/response':(BuildContext context) => ResponseView()
};
