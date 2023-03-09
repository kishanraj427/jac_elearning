import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:jac_elearning/controller/QPDFController.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// ignore: must_be_immutable
class OpenPDFQuestion extends StatelessWidget {
  String name, pdfUrl, noti;
  OpenPDFQuestion({this.name, this.pdfUrl});
  final pdfViewerController = new PdfViewerController();

  @override
  Widget build(BuildContext context) {
    final pdfController = Get.put(QPDFController(name: name, url: pdfUrl),
        permanent: true, tag: name);

    return Obx(() {
      return WillPopScope(
          onWillPop: () async {
            bool h = true;
            if (pdfController.hide.value) {
              pdfController.hide.value = false;
              pdfController.expand();
              return !h;
            }
            pdfController.interstitialAd.value.show();
            return h;
          },
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: pdfController.hide.value
                  ? null
                  : AppBar(
                      title:
                          Text(name, style: TextStyle(color: Colors.redAccent)),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.fullscreen_outlined),
                          onPressed: () {
                            pdfController.hide.value = true;
                            pdfController.expand();
                          },
                        ),
                      ],
                    ),
              body: Stack(
                children: [
                  SfPdfViewer.network(
                    pdfUrl,
                    controller: pdfViewerController,
                    canShowPaginationDialog: true,
                    canShowScrollHead: true,
                    canShowScrollStatus: true,
                  ),
                  Positioned(
                    bottom: 0.5,
                    child: Container(
                      width: Get.width,
                      height: Get.height * 0.1,
                      alignment: Alignment.bottomCenter,
                      child: pdfController.banner.value
                    )
                    ),

                ],
              ),

            ));
    },
    );
  }
}
