import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jac_elearning/controller/NewsController.dart';
import 'package:jac_elearning/models/News.dart';
import 'package:jac_elearning/widgets/Header.dart';
import 'package:jac_elearning/widgets/NewsWidget.dart';
import '../../AppColor.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String test = "";
  News news = new News();
  NewsController newsController;
  final controller = TextEditingController();
  final controller2 = TextEditingController();
  @override
  void initState() {
    newsController = Get.put(NewsController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Header(
              path: 'assets/lottie/news3.json',
              title: "Hi learner",
              description: "Welcome to the World of JAC eLearning",
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 5),
            sliver: SliverAppBar(
              pinned: true,
              floating: true,
              centerTitle: true,
              title: Container(
                // width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                  "Notifications",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sen(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ),
          ),
          Obx(
            () => newsController.newsList.length == 0
                ? SliverToBoxAdapter(
                    child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 100),
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                    ),
                  ))
                : SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    itemCount: newsController.newsList.length,
                    itemBuilder: (context, index) {
                      return NewsWidget(
                        id: newsController.newsList[index].key,
                        text: newsController.newsList[index].text,
                        type: newsController.newsList[index].type,
                        url: newsController.newsList[index].url,
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
    );
  }
}
