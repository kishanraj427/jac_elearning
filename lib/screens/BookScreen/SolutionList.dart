import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jac_elearning/models/Book.dart';
import 'package:jac_elearning/widgets/BookWidget.dart';

import '../../AppColor.dart';

// ignore: must_be_immutable
class SolutionList extends StatefulWidget {
  String clas, subject;
  SolutionList({this.clas, this.subject});

  @override
  _SolutionListState createState() => _SolutionListState();
}

class _SolutionListState extends State<SolutionList> {
  DatabaseReference rootRef;
  var bookList = <Book>[];
  var controller = TextEditingController();
  File pdfFile;

  @override
  void initState() {
    rootRef = FirebaseDatabase.instance
        .reference()
        .child("Books")
        .child(widget.clas)
        .child(widget.subject)
        .child("SolutionList");
    super.initState();
    loadData();
  }

  loadData() async {
    await rootRef.onChildAdded.forEach((event) {
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
      body: bookList.length == 0
          ? Container(
              alignment: Alignment.center,
              child: Text('Nothing to Show',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent)),
            )
          : StaggeredGridView.countBuilder(
              padding: EdgeInsets.symmetric(vertical: 10),
              physics: BouncingScrollPhysics(),
              crossAxisCount: 1,
              itemCount: bookList.length,
              itemBuilder: (context, index) {
                return BookWidget(
                  clas: widget.clas,
                  subject: widget.subject,
                  type: "Solutions",
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
