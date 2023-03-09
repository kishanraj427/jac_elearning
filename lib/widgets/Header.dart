import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../AppColor.dart';

// ignore: must_be_immutable
class Header extends StatelessWidget {
  String path, title, description;
  Header({this.path, this.title, this.description});
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.start,
              style: GoogleFonts.montserrat(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: AppColor.mainColor),
            ),
            Text(
              description,
              textAlign: TextAlign.start,
              style: GoogleFonts.mPlusRounded1c(
                  fontSize: 14,
                  wordSpacing: 0,
                  color: AppColor.title,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: screenSize.height * 0.25,
              width: screenSize.width,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 7,
                      spreadRadius: 2,
                      offset: Offset(2, 2),
                    )
                  ]),
              child: Lottie.asset(
                path,
                height: screenSize.height * 0.25,
                width: screenSize.width,
                fit: BoxFit.contain,
                repeat: true,
              ),
            )
          ],
        ));
  }
}
