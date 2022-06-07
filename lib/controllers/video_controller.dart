import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/video.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoLsit = Rx<List<Video>>([]);

  List<Video> get videoList => _videoLsit.value;

  @override
  void onInit() {
    super.onInit();
    _videoLsit.bindStream(firestore
        .collection('videos')
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<Video> returnValue = [];
      for (var element in querySnapshot.docs) {
        returnValue.add(
          Video.fromSnap(element),
        );
      }
      return returnValue;
    }));
  }

  LikeVideo(String id) async {
    DocumentSnapshot snap = await firestore.collection('videos').doc(id).get();
    var uid = authController.user.uid;
    if ((snap.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
