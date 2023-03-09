import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jac_elearning/screens/BookScreen/OpenPDF.dart';

// ignore: must_be_immutable
class RecentBookWidget extends StatelessWidget {
  String url, name, clas, subject, type;
  RecentBookWidget({this.clas, this.type, this.subject, this.name, this.url});

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
              builder: (_) => OpenPDF(
                    clas: clas,
                    subject: subject,
                    type: type,
                    name: name,
                    pdfUrl: url,
                  )));
        },
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "$name\n($type)",
            textAlign: TextAlign.center,
            style: GoogleFonts.mPlusRounded1c(
                fontSize: 18,
                wordSpacing: 0.8,
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
