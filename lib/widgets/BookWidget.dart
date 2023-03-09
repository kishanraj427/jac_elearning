import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jac_elearning/screens/BookScreen/OpenPDF.dart';

// ignore: must_be_immutable
class BookWidget extends StatelessWidget {
  String title, pdfUrl, clas, subject, type;
  BookWidget({this.clas, this.type, this.subject, this.title, this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.redAccent,
                Color(0xffff9472),
              ],
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
        height: 90,
        splashColor: Colors.white54,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => OpenPDF(
                    clas: clas,
                    subject: subject,
                    type: type,
                    name: title,
                    pdfUrl: pdfUrl,
                  )));
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            textAlign: TextAlign.start,
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
