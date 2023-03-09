import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionController extends GetxController {
  RxList questionList = [].obs;
  RxList recentList = [].obs;
  final rootRef = FirebaseDatabase.instance.reference().child("Question");

  @override
  void onInit() {
    questionList.reversed;
    loadRecent();
    loadData();
    super.onInit();
  }

  loadData() async {
    print('load data start');
    rootRef.onChildAdded.listen((event) {
      Map data = event.snapshot.value;
      var name = data["name"];
      questionList.insert(0, name);
      print(name);
    });
  }

  loadRecent() async {
    recentList.clear();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var list = preferences.getStringList('recentQuestionList');
    if (list != null) {
      list.forEach((element) {
        var data = jsonDecode(element);
        recentList.insert(0, data);
      });
    }
  }
}
