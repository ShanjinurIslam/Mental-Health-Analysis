import 'package:flutter/material.dart';

class Problems extends StatelessWidget {
  List<String> problems = [
    'Anger',
    'Anxiety',
    'Depression',
    'Mania',
    'Sleep Disturbance',
    'Substance Use'
  ];
  List<String> images = [
    'anger',
    'anxiety',
    'depression',
    'mania',
    'sleep_disturbance',
    'substance'
  ];

  List<int> numbers = [5, 8, 7, 6, 9, 8];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
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
            child: PageView.builder(
              //physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
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
                          Image.asset(
                            'images/' + images[index] + '.png',
                          ),
                          Spacer(),
                          Text(
                            problems[index],
                            style: TextStyle(fontSize: 24),
                          ),
                          Text(
                            numbers[index].toString() + ' Questions',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: problems.length,
            ),
            flex: 6,
          ),
        ],
      ),
    );
  }
}
