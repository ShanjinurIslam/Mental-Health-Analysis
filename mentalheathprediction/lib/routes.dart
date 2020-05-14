import 'package:flutter/material.dart';
import 'package:mentalheathprediction/views/home.dart';
import 'package:mentalheathprediction/views/sign_in.dart';

final routes = {
  '/': (BuildContext context) => SignInView(),
  '/home': (BuildContext context) => Home()
};
