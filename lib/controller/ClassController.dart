import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassController extends GetxController {
  RxList classList = [].obs;
  RxList recentList = [].obs;
  final rootRef = FirebaseDatabase.instance.reference().child("Books");

  @override
  void onInit() {
    loadData();
    loadRecent();
    super.onInit();
  }

  loadData() async {
    rootRef.onChildAdded.listen((event) {
      Map data = event.snapshot.value;
      var name = data["name"];
      classList.insert(0, name);
    });
  }

  loadRecent() async {
    recentList.clear();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var list = preferences.getStringList('recentBookList');
    if (list != null) {
      list.forEach((element) {
        var data = jsonDecode(element);
        recentList.insert(0, data);
      });
    }
  }
}
