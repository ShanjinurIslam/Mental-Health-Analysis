import 'package:flutter/material.dart';
import 'package:mentalheathprediction/views/problems.dart';
import 'package:mentalheathprediction/views/profile.dart';
import 'package:mentalheathprediction/views/reports.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  int _currentIndex = 0;
  List<Widget> children = [Problems(), Reports(), Profile()];
  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.green,
            currentIndex: _currentIndex,
            onTap: onTapped,
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                title: new Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.mail),
                title: new Text('Responses'),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text('Profile'))
            ]),
        body: children[_currentIndex]);
  }
}
