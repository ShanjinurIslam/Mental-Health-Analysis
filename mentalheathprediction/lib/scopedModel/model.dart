import 'package:mentalheathprediction/models/user.dart';
import 'package:scoped_model/scoped_model.dart';

class MyModel extends Model {
  User user;
  List<List<String>> checkedArr;
  void setUser(User user) {
    this.user = user;
  }

  void setCheckArr(int index, List<String> arr) {
    checkedArr[index] = arr;
    notifyListeners();
  }

  void initCheckArr() {
    checkedArr = List.filled(10, new List<String>());
    notifyListeners();
  }

  int calculateRawScore(int size) {
    int score = 0;
    for (int i = 0; i < size; i++) {
      String level = checkedArr[i][0];
      if (level == "Never") {
        score += 1;
      } else if (level == "Rarely") {
        score += 2;
      } else if (level == "Sometimes") {
        score += 3;
      } else if (level == "Often") {
        score += 4;
      } else {
        score += 5;
      }
    }
    
    return score;
  }
}
