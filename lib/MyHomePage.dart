import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jac_elearning/screens/BookScreen/Books.dart';
import 'AppColor.dart';
import 'package:get/get.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'screens/HomeScreen/Home.dart';
import 'screens/QuestionScreen/Question.dart';
import 'package:share/share.dart' as Share;
import 'package:path_provider/path_provider.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int appVersion = 4;
  int currentPage = 0;
  DatabaseReference rootRef = FirebaseDatabase.instance.reference();
  PageController controller;
  List<String> title = ["Home", "Books", "Questions"];
  String androidAppURL =
      "https://play.google.com/store/apps/details?id=com.jac.jacboard.jacquestion.jac_elearning";

  @override
  void initState() {
    downloadImage();
    super.initState();
    controller = PageController(initialPage: currentPage);
  }

  downloadImage() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      Get.snackbar('Connection Error', 'Please Turn on your Internet!',
          snackPosition: SnackPosition.TOP,
          borderColor: Colors.redAccent,
          borderWidth: 2,
          duration: Duration(seconds: 6),
          backgroundColor: AppColor.white);
    }
    bool file =
        await File((await p.getExternalStorageDirectory()).path + "/image.png")
            .exists();
    if (!file) {
      final bytes = await rootBundle.load('assets/images/jacImage.png');
      new File((await p.getExternalStorageDirectory()).path + "/image.png")
          .writeAsBytes(bytes.buffer.asUint8List());
    }
    rootRef.child('App Version').once().then((value) {
      if (value.value >= appVersion) showUpdate();
    });
  }

  showUpdate() {
    Get.defaultDialog(
        title: 'Update JAC eLearning',
        titleStyle: GoogleFonts.sen(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
        middleText: 'A new version of JAC eLearning is available! Update Now.',
        middleTextStyle: GoogleFonts.mPlusRounded1c(
            color: Colors.black87,
            fontSize: 18,
            wordSpacing: -0.7,
            fontWeight: FontWeight.w400),
        actions: [
          // ignore: deprecated_member_use
          FlatButton(
              color: Colors.redAccent,
              onPressed: () {
                Get.back();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              )),
          // ignore: deprecated_member_use
          FlatButton(
              color: Colors.redAccent,
              onPressed: () {
                launch(androidAppURL);
              },
              child: Text(
                'Done',
                style: TextStyle(color: Colors.white),
              ))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: AppColor.background,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          title: Text(
            title[currentPage],
            style: GoogleFonts.sen(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.redAccent),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.menu_rounded,
                color: Colors.redAccent,
              ),
              onPressed: () async {
                await bottomsheet(context);
              }),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.share_rounded,
                  color: Colors.redAccent,
                ),
                onPressed: () async {
                  File data = new File(
                      (await p.getExternalStorageDirectory()).path +
                          "/image.png");
                  print(data);
                  await data.exists()
                      ? Share.Share.shareFiles([data.path],
                          text: "*Download JAC eLearning App :*\n$androidAppURL")
                      : Share.Share.share(
                          "*Download JAC eLearning App :*\n$androidAppURL");
                })
          ],
          centerTitle: true,
          backgroundColor: AppColor.background,
          elevation: 0,
        ),
        body: PageView(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          onPageChanged: (value) {
            setState(() {
              currentPage = value;
            });
          },
          children: [Home(), Books(), Question()],
        ),
        bottomNavigationBar: BottomNavyBar(
          backgroundColor: AppColor.background,
          showElevation: true,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          animationDuration: Duration(milliseconds: 300),
          itemCornerRadius: 15,
          onItemSelected: (value) {
            setState(() {
              currentPage = value;
              controller.jumpToPage(value);
            });
          },
          selectedIndex: currentPage,
          items: [
            navyBar(Icons.home_rounded, 'Home'),
            navyBar(Icons.dashboard, 'Books'),
            navyBar(Icons.article, 'Questions'),
          ],
        ));
  }

  BottomNavyBarItem navyBar(IconData icon, String str) {
    return BottomNavyBarItem(
        icon: Icon(icon),
        title: Text(str),
        inactiveColor: AppColor.text,
        activeColor: Colors.redAccent);
  }

  bottomsheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      enableDrag: true,
      elevation: 3,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              onTap: () {
                Get.back();
                result();
              },
              hoverColor: Colors.redAccent,
              leading: Icon(
                Icons.article,
                color: Colors.black87,
              ),
              title: Text(
                'JAC Result',
                textAlign: TextAlign.start,
                style: GoogleFonts.mPlusRounded1c(
                    fontSize: 18,
                    wordSpacing: 0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              onTap: () {
                launch(
                  'https://jac.jharkhand.gov.in/jac/',
                  enableJavaScript: true,
                );
                Get.back();
              },
              hoverColor: Colors.redAccent,
              leading: Icon(
                Icons.account_balance_rounded,
                color: Colors.black87,
              ),
              title: Text(
                'JAC Official Website',
                textAlign: TextAlign.start,
                style: GoogleFonts.mPlusRounded1c(
                    fontSize: 18,
                    wordSpacing: 0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              onTap: () {
                final uri = Uri(
                    scheme: 'mailto',
                    path: 'jacelearnig@gmail.com',
                    query:
                        'subject=JAC eLearning Feedback&body=App Version 1.0.5');
                launch(uri.toString());
                Get.back();
              },
              hoverColor: Colors.redAccent,
              leading: Icon(
                Icons.email_rounded,
                color: Colors.black87,
              ),
              title: Text(
                'Feedback',
                textAlign: TextAlign.start,
                style: GoogleFonts.mPlusRounded1c(
                    fontSize: 18,
                    wordSpacing: 0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              onTap: () {
                launch(androidAppURL);
                Get.back();
              },
              hoverColor: Colors.redAccent,
              leading: Icon(
                Icons.star_rate_outlined,
                color: Colors.black87,
              ),
              title: Text(
                'Rate',
                textAlign: TextAlign.start,
                style: GoogleFonts.mPlusRounded1c(
                    fontSize: 18,
                    wordSpacing: 0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        );
      },
    );
  }

  result() {
    Get.defaultDialog(
        title: 'JAC Result',
        titleStyle: TextStyle(color: Colors.black, fontSize: 20),
        content: Column(
          children: [
            tile('JAC 09th', 'Result/09th'),
            tile('JAC 10th', 'Result/10th'),
            tile('JAC 11th Science', 'Result/11th/Science'),
            tile('JAC 11th Commerce', 'Result/11th/Commerce'),
            tile('JAC 11th Arts', 'Result/11th/Arts'),
            tile('JAC 12th Science', 'Result/12th/Science'),
            tile('JAC 12th Commerce', 'Result/12th/Commerce'),
            tile('JAC 12th Arts', 'Result/12th/Arts'),
          ],
        ));
  }

  ListTile tile(String str, String url) {
    return ListTile(
      onTap: () async {
        var result = await Connectivity().checkConnectivity();
        if (result != ConnectivityResult.none) {
          rootRef.child(url).once().then((value) {
            launch(value.value, enableJavaScript: true);
          });
        } else {
          Get.back();
          Get.snackbar('Connection Error', 'Please Turn on your Internet!',
              snackPosition: SnackPosition.TOP,
              borderColor: Colors.redAccent,
              borderWidth: 2,
              backgroundColor: AppColor.white);
        }
      },
      hoverColor: Colors.redAccent,
      leading: Icon(
        Icons.article,
        color: Colors.black87,
      ),
      title: Text(
        str,
        textAlign: TextAlign.start,
        style: GoogleFonts.mPlusRounded1c(
            fontSize: 18,
            wordSpacing: 0,
            color: Colors.black87,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
