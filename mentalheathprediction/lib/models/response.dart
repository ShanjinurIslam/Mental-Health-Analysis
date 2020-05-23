class Response {
  final String id;
  final String problem;
  final String catagory;
  final String submittedAt;

  Response({this.id, this.problem, this.catagory, this.submittedAt});

  factory Response.fromJSON(Map<String, dynamic> json) {
    return Response(
        id: json['_id'],
        problem: json['problem']['name'],
        catagory: json['catagory'],
        submittedAt: json['submittedAt']);
  }
}
