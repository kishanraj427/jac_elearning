import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jac_elearning/models/Subject.dart';

class SubjectController extends GetxController {
  String clas;
  SubjectController({@required this.clas});
  RxList subjectList = [].obs;
  DatabaseReference rootRef;

  @override
  void onInit() {
    rootRef = FirebaseDatabase.instance.reference().child("Books").child(clas);
    loadData();
    super.onInit();
  }

  loadData() async {
    try {
      rootRef.onChildAdded.listen((event) {
        var data = event.snapshot.value;
        var subject = Subject(clas: data["clas"], subjectName: data["subject"]);
        subjectList.add(subject);
      });
    } catch (e) {
      print(e);
    }
  }
}
