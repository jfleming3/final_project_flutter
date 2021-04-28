class gradeModel{

  final String type;
  final String score;

  gradeModel({this.score, this.type});

  Map<String, dynamic> toMap(){
    return{
      "type" : this.type,
      "score" : this.score
    };
  }
}