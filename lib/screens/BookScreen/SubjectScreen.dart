import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:jac_elearning/controller/SubjectController.dart';
import 'package:jac_elearning/widgets/SubjectWidget.dart';
import '../../AppColor.dart';

// ignore: must_be_immutable
class SubjectScreen extends StatefulWidget {
  String clas;
  SubjectScreen({Key key, this.clas}) : super(key: key);

  @override
  _SunjectState createState() => _SunjectState();
}

class _SunjectState extends State<SubjectScreen> {
  Size screenSize;
  TextEditingController controller = TextEditingController();
  SubjectController subjectController;

  @override
  void initState() {
    subjectController = Get.put(SubjectController(clas: widget.clas),
        permanent: true, tag: widget.clas);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(widget.clas,
            style: TextStyle(
              color: Colors.red,
            )),
      ),
      body: Obx(() => StaggeredGridView.countBuilder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 10),
            crossAxisCount: 2,
            itemCount: subjectController.subjectList.length,
            itemBuilder: (context, index) {
              return SubjectWidget(
                clas: subjectController.subjectList[index].clas,
                subject: subjectController.subjectList[index].subjectName,
              );
            },
            staggeredTileBuilder: (index) {
              return new StaggeredTile.fit(1);
            },
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          )),
    );
  }
}
