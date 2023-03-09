import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:jac_elearning/models/News.dart';
import 'package:device_id/device_id.dart' as Device;

class NewsController extends GetxController {
  RxList newsList = [].obs;
  String deviceId;
  Rx<DatabaseReference> rootRef =
      FirebaseDatabase.instance.reference().child('News').obs;
  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  loadData() async {
    deviceId = await Device.DeviceId.getID;
    try {
      rootRef.value.onChildAdded.listen((event) {
        var data = event.snapshot.value;
        var news = News(
            key: data['key'],
            type: data['type'],
            text: data['text'],
            url: data['url']);
        newsList.insert(0, news);
      });
    } catch (e) {
      print(e);
    }
  }
}
