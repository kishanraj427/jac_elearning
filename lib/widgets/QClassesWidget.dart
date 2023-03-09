import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jac_elearning/controller/QSubjectController.dart';
import 'package:jac_elearning/screens/QuestionScreen/QSubjectScreen.dart';
import 'QSubjectWidget.dart';

// ignore: must_be_immutable
class QClassesWidget extends StatefulWidget {
  String title;
  QClassesWidget({this.title});

  @override
  State<StatefulWidget> createState() => ClassesWidget2State();
}

class ClassesWidget2State extends State<QClassesWidget> {
  QSubjectController controller;
  String title;
  @override
  void initState() {
    title = widget.title;
    controller = Get.put(QSubjectController(clas: widget.title));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller = Get.put(QSubjectController(clas: widget.title),
        permanent: true, tag: widget.title);
    //Get.create(() => SubjectController(clas: title));
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 0,
                    blurRadius: 2,
                    offset: Offset(0.8, 0.8)),
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => QSubjectScreen(
                            clas: title,
                          )));
                },
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.mPlusRounded1c(
                      fontSize: 20,
                      wordSpacing: 0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => QSubjectScreen(
                            clas: title,
                          )));
                },
                child: Text(
                  "See All",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.mPlusRounded1c(
                      fontSize: 20,
                      wordSpacing: 0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200),
            child: Obx(() => controller.subjectList.length == 0
                ? CircularProgressIndicator.adaptive()
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    //shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemCount: controller.subjectList.length,
                    itemBuilder: (context, index) {
                      return QSubjectWidget(
                        clas: controller.subjectList[index].clas,
                        subject: controller.subjectList[index].subjectName,
                      );
                    },
                  ))),
      ],
    );
  }
}
