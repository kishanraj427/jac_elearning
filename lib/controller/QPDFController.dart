import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'QuestionController.dart';
import 'package:flutter_google_ad_manager/flutter_google_ad_manager.dart';

class QPDFController extends GetxController {
  String url, name;
  RxBool hide = false.obs;
  Rx<DFPBanner> banner = DFPBanner(
        isDevelop: false,
        adUnitId: 'ca-app-pub-7992530201347666/6612650124',
        adSize: DFPAdSize.BANNER,
        onAdLoaded: () {
        print('Banner onAdLoaded');
        },
        onAdFailedToLoad: (errorCode) {
        print('Banner onAdFailedToLoad: errorCode:$errorCode');
        },
        onAdOpened: () {
        print('Banner onAdOpened');
        },
        onAdClosed: () {
        print('Banner onAdClosed');
        },
        onAdLeftApplication: () {
        print('Banner onAdLeftApplication');
        },
  ).obs;

  Rx<DFPInterstitialAd> interstitialAd = DFPInterstitialAd(
  isDevelop: false,
  adUnitId: "ca-app-pub-7992530201347666/9442186968",
  onAdLoaded: () {
  print('interstitialAd onAdLoaded');
  },
  onAdFailedToLoad: (errorCode) {
  print('interstitialAd onAdFailedToLoad: errorCode:$errorCode');
  },
  onAdOpened: () {
  print('interstitialAd onAdOpened');
  },
  onAdClosed: () {
  print('interstitialAd onAdClosed');
  },
  onAdLeftApplication: () {
  print('interstitialAd onAdLeftApplication');
  },
  ).obs;

  RxInt pageNo = 0.obs;


  QPDFController({this.name, this.url});
  @override
  void onInit() {
    super.onInit();
    addToRecent();
    loadPDFPage();
    interstitialAd.value.load();
  }



  loadPDFPage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int data = preferences.getInt(name);
    pageNo.value = data != null ? data : 0;
  }


  expand() {
    hide.value
        ? SystemChrome.setEnabledSystemUIOverlays([])
        : SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    Fluttertoast.showToast(
        msg: hide.value ? "FullScreen Enable" : "FullScreen Disable");
  }

  addToRecent() async {
    //var recentBookList = <RecentBook>[];
    var book = Map<String, String>();
    book['name'] = name;
    book['url'] = url;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var list = preferences.getStringList('recentQuestionList');
    if (list == null) list = [];
    String str = json.encode(book);
    if (list.contains(str)) list.remove(str);
    list.add(str);
    if (list.length > 5) list.removeAt(0);
    preferences.setStringList('recentQuestionList', list);
    Get.find<QuestionController>().loadRecent();
  }
}
