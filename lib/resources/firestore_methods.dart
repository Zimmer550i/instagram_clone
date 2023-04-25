import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/post_model.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "Some error occured";

    try {
      String postId = const Uuid().v1();
      String photoUrl =
          await StorageMethods().uploadImagetoStorage('posts', file, postId);

      Post post = Post(
        caption: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "Success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some Error Occured";

    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update(
          {
            "likes": FieldValue.arrayRemove([uid]),
          },
        );
      }else{
        await _firestore.collection('posts').doc(postId).update(
          {
            "likes": FieldValue.arrayUnion([uid]),
          },
        );
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> deletePost(String postId, String uid, String photoUrl) async{
    String res = "Some Error Occured";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = await StorageMethods().deletePostPhoto(photoUrl);
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
