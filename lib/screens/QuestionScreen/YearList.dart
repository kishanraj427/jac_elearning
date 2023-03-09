import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jac_elearning/models/Book.dart';
import 'package:jac_elearning/widgets/QuestionWidget.dart';

import '../../AppColor.dart';

// ignore: must_be_immutable
class YearList extends StatefulWidget {
  String clas, subject;
  YearList({this.clas, this.subject});

  @override
  _YearListState createState() => _YearListState();
}

class _YearListState extends State<YearList> {
  DatabaseReference rootRef;
  var bookList = <Book>[];
  var controller = TextEditingController();
  File pdfFile;

  @override
  void initState() {
    rootRef = FirebaseDatabase.instance
        .reference()
        .child("Question")
        .child(widget.clas)
        .child(widget.subject);
    super.initState();
    loadData();
  }

  loadData() {
    rootRef.onChildAdded.listen((event) {
      var data = event.snapshot.value;
      var book = Book(
          name: data["name"].toString(), pdfUrl: data['pdfUrl'].toString());
      setState(() {
        bookList.add(book);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(widget.subject,
            style: TextStyle(
              color: Colors.red,
            )),
      ),
      body: StaggeredGridView.countBuilder(
        padding: EdgeInsets.symmetric(vertical: 10),
        physics: BouncingScrollPhysics(),
        crossAxisCount: 1,
        itemCount: bookList.length,
        itemBuilder: (context, index) {
          return QuestionWidget(
            title: bookList[index].name,
            pdfUrl: bookList[index].pdfUrl,
          );
        },
        staggeredTileBuilder: (index) {
          return new StaggeredTile.fit(1);
        },
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
    );
  }
}
