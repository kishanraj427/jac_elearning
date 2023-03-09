import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share/share.dart';
import 'package:get/get.dart';
import 'package:jac_elearning/controller/PDFController.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../AppColor.dart';

// ignore: must_be_immutable
class OpenPDF extends StatelessWidget {
  String name, pdfUrl, clas, subject, type;
  OpenPDF({this.clas, this.type, this.subject, this.name, this.pdfUrl});
  final pdfViewerController = new PdfViewerController();

  @override
  Widget build(BuildContext context) {
    final pdfController = Get.put(
        PDFController(
            clas: clas, type: type, subject: subject, name: name, url: pdfUrl),
        permanent: true,
        tag: type + name);
    return Obx(() {
      return WillPopScope(
          onWillPop: () async {
            bool h = true;
            if (pdfController.hide.value) {
              pdfController.hide.value = false;
              pdfController.expand();
              return !h;
            }
            pdfController.setData();
            pdfController.interstitialAd.value.show();
            return h;
          },
          child: Scaffold(
              backgroundColor: AppColor.background,
              resizeToAvoidBottomInset: false,
              appBar: pdfController.hide.value
                  ? null
                  : AppBar(
                      title:
                          Text(name, style: TextStyle(color: Colors.redAccent)),
                      actions: [
                        IconButton(
                            icon: Icon(
                              Icons.ios_share_rounded,
                              color: Colors.redAccent,
                            ),
                            onPressed: () async {
                              File data = File(
                                  '${pdfController.directory.path}/$name.pdf');
                              await data.exists()
                                  ? Share.shareFiles([data.path],
                                      text: "Shared from JAC eLearning App")
                                  : Fluttertoast.showToast(
                                      msg: "Unable to Share",
                                      backgroundColor: Colors.redAccent,
                                      textColor: Colors.white,
                                      gravity: ToastGravity.BOTTOM,
                                      toastLength: Toast.LENGTH_SHORT);
                            }),
                        IconButton(
                          icon: Icon(Icons.fullscreen_outlined),
                          onPressed: () {
                            pdfController.hide.value = true;
                            pdfController.expand();
                          },
                        ),
                      ],
                    ),
              body: Stack(children: [
                pdfController.isLoaded.value
                    ? SfPdfViewer.file(
                        pdfController.file,
                        controller: pdfViewerController,
                        canShowPaginationDialog: true,
                        canShowScrollHead: true,
                        canShowScrollStatus: true,
                        enableDoubleTapZooming: true,
                        onDocumentLoaded: (details) {
                          pdfViewerController
                              .jumpToPage(pdfController.pageNo.value);
                        },
                        onPageChanged: (details) {
                          pdfController.pageNo.value = details.newPageNumber;
                        },
                      )
                    : Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                strokeWidth: 7,
                              ),
                              Center(
                                child: Text(
                                  pdfController.downData.value
                                          .toStringAsFixed(0) +
                                      "%",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 30),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                Positioned(
                  bottom: 0.5,
                  child: Container(
                    width: Get.width,
                    height: Get.height * 0.1,
                    alignment: Alignment.bottomCenter,
                    child: pdfController.banner.value
                  ),
                )
              ])));
    });
  }
}
