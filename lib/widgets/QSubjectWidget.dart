import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jac_elearning/screens/QuestionScreen/YearList.dart';

// ignore: must_be_immutable
class QSubjectWidget extends StatelessWidget {
  String clas, subject;
  QSubjectWidget({this.clas, this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.redAccent, Color(0xffffac69)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.2, 1]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(2, 2),
            ),
          ]),
      child: MaterialButton(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        splashColor: Colors.white54,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => YearList(
                    clas: clas,
                    subject: subject,
                  )));
        },
        child: Align(
          alignment: Alignment.center,
          child: Text(
            subject,
            textAlign: TextAlign.center,
            style: GoogleFonts.mPlusRounded1c(
                fontSize: 20,
                wordSpacing: 0,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
