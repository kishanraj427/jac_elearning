import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jac_elearning/controller/ClassController.dart';
import 'package:jac_elearning/widgets/ClassesWidget.dart';
import 'package:jac_elearning/widgets/Header.dart';
import 'package:jac_elearning/AppColor.dart';
import 'package:jac_elearning/widgets/RecentBookWidget.dart';

class Books extends StatefulWidget {
  @override
  BooksState createState() => BooksState();
}

class BooksState extends State<Books> {
  Size screenSize;
  TextEditingController controller = TextEditingController();
  ClassController classController;

  @override
  void initState() {
    classController = Get.put(ClassController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Header(
              path: 'assets/lottie/study_stand.json',
              title: "JAC Books",
              description: "Get all books related JAC Board",
            ),
          ),
          Obx(() => SliverToBoxAdapter(
                child: classController.recentList.length == 0
                    ? Container()
                    : recentDat(context),
              )),
          Obx(
            () => classController.classList.length == 0
                ? SliverToBoxAdapter(
                    child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 100),
                    child: CircularProgressIndicator.adaptive(
                      
                    ),
                  ))
                : SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    itemCount: classController.classList.length,
                    itemBuilder: (context, index) {
                      return ClassesWidget(
                        title: classController.classList[index],
                      );
                    },
                    staggeredTileBuilder: (index) {
                      return new StaggeredTile.fit(1);
                    },
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
          )
        ],
      ),
      backgroundColor: AppColor.background,
    );
  }

  Widget recentDat(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
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
          child: Text(
            "Recent",
            textAlign: TextAlign.start,
            style: GoogleFonts.mPlusRounded1c(
                fontSize: 20,
                wordSpacing: 0,
                color: Colors.black87,
                fontWeight: FontWeight.w600),
          ),
        ),
        ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200),
            child: Obx(() => ListView.builder(
                  physics: BouncingScrollPhysics(),
                  // shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  itemCount: classController.recentList.length,
                  itemBuilder: (context, index) {
                    return RecentBookWidget(
                        clas: classController.recentList[index]['clas'],
                        subject: classController.recentList[index]['subject'],
                        type: classController.recentList[index]['type'],
                        name: classController.recentList[index]['name'],
                        url: classController.recentList[index]['url']);
                  },
                ))),
      ],
    );
  }
}
