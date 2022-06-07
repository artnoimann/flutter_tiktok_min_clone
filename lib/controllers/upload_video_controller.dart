import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  //compress video before upload
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );

    return compressedVideo!.file;
  }

  //upload video to firestore
  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);
    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  //get thumbnail
  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  //upload image for video
  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  //upload video controller
  uploadVideo(String songName, String caption, String videoPath) async {

    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();

      //about user from firebase
      var thisUser = (userDoc.data()! as Map<String, dynamic>);

      //get video id
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;

      String thumbnail = await _uploadImageToStorage('Video $len', videoPath);
      String videoUrl = await _uploadVideoToStorage('Video $len', videoPath);

      sleep(const Duration(seconds: 5));
      if(thumbnail != null && videoUrl != null) {
        Video video = Video(
          username: thisUser['name'],
          uid: uid,
          id: 'Video $len',
          likes: [],
          commentCount: 0,
          shareCount: 0,
          songName: songName,
          caption: caption,
          videoUrl: videoUrl,
          thumbnail: thumbnail,
          profilePhoto: thisUser['profilePic'],
        );

        await firestore
            .collection('videos')
            .doc('Video $len')
            .set(
          video.toJson(),
        );
        Get.back();
      }

    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Error uploading video',
        e.toString(),
      );
    }
  }
}
