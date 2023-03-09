import 'dart:io';

class News {
  String text, type, url, key;
  File pdf, image;
  News({this.key, this.type, this.text, this.url});
  String toString() {
    return "Type: $type\nText: $text\nUrl: $url\nPdf: $pdf\nImage: $image";
  }
}
