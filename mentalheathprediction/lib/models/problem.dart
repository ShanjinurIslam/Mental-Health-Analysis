class Problem {
  final String id;
  final String name;

  Problem({this.id, this.name});

  factory Problem.fromJSON(Map<String, dynamic> json) {
    return Problem(id: json['_id'], name: json['name']);
  }
}
