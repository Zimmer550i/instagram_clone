import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String caption;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final List likes;

  const Post({
    required this.caption,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'uid': uid,
    'caption': caption,
    'postId': postId,
    'datePublished': datePublished,
    'profImage': profImage,
    'likes': likes,
    'postUrl': postUrl,
  };

  static Post fromSnap(DocumentSnapshot snap){
    Map snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      caption: snapshot['caption'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
      postUrl: snapshot['postUrl'],
    );
  }
}