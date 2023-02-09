import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class StorageMethods{
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  uploadImagetoStorage(String childName, Uint8List file, [String? id])async{
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if(id!=null){
      ref = ref.child(id);
    }

    UploadTask uploadTask = ref.putData(await FlutterImageCompress.compressWithList(file, quality: 50));
    
    TaskSnapshot snap =  await uploadTask;

    return await snap.ref.getDownloadURL();
  }
}