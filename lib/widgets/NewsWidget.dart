import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jac_elearning/controller/NewsController.dart';
import 'package:photo_view/photo_view.dart';
import 'package:simple_url_preview/simple_url_preview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../AppColor.dart';

// ignore: must_be_immutable
class NewsWidget extends StatelessWidget {
  String url, type, id, text;
  NewsWidget({this.id, this.type, this.text, this.url});

  getUID() async {
    Get.find<NewsController>()
        .rootRef
        .value
        .child(id)
        .child('view')
        .child(Get.find<NewsController>().deviceId)
        .set(0);
  }

  launchUrl() async {
    launch(
      url,
      enableJavaScript: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return InkWell(
        onTap: () async {
          getUID();
          if (type == "PDF") {
            Get.generalDialog(
              barrierDismissible: false,
              barrierColor: AppColor.background,
              pageBuilder: (context, animation, secondaryAnimation) {
                return Scaffold(
                    appBar: AppBar(
                        title: Text(
                      text,
                      style: TextStyle(color: Colors.redAccent),
                    )),
                    body: SizedBox.expand(child: SfPdfViewer.network(url)));
              },
            );
          } else if (type == "IMAGE") {
            Get.generalDialog(
              barrierDismissible: false,
              barrierColor: AppColor.background,
              pageBuilder: (context, animation, secondaryAnimation) {
                return SizedBox.expand(
                  child: PhotoView(
                    imageProvider: NetworkImage(url),
                  ),
                );
              },
            );
          } else {
            launchUrl();
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(1.5, 1.5)),
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: widget(context),
          ),
        ));
  }

  Widget widget(BuildContext context) {
    if (type == "URL") return urlWidget();
    if (type == "IMAGE") return imageWidget(context);
    if (type == "PDF") return tile(Icons.picture_as_pdf_rounded);
    return Container();
  }

  Widget urlWidget() {
    return Column(
      children: [
        text == null
            ? SimpleUrlPreview(
                url: url,
                bgColor: Colors.white,
                previewHeight: 140,
                titleStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                descriptionStyle: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w400),
                imageLoaderColor: Colors.purple[300],
                onTap: () {
                  getUID();
                  launchUrl();
                },
              )
            : Container(),
        text != null ? tile(Icons.article_rounded) : Container(),
      ],
    );
  }

  Widget imageWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0.8, 0.8)),
          ]),
      child: Column(
        children: [
          Image.network(
            url,
            fit: BoxFit.fitWidth,
            height: 150,
            width: MediaQuery.of(context).size.width - 20,
          ),
          text != null
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.mPlusRounded1c(
                          fontSize: 18,
                          wordSpacing: 0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget tile(IconData icon) {
    return ListTile(
      dense: true,
      hoverColor: Colors.redAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      leading: Icon(
        icon,
        color: Colors.redAccent,
        size: 30,
      ),
      tileColor: Colors.white,
      title: Text(
        text,
        textAlign: TextAlign.start,
        style: GoogleFonts.mPlusRounded1c(
            fontSize: 18,
            wordSpacing: 0,
            color: Colors.black87,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
