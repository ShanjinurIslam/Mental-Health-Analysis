class Question {
  final String engQuestion;
  final String bngQuestion;

  Question({this.engQuestion, this.bngQuestion});

  factory Question.fromJSON(Map<String, dynamic> json) {
    return Question(
        bngQuestion: json['bngQuestion'], engQuestion: json['engQuestion']);
  }
}
