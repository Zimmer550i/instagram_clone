import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? img;
  final TextEditingController _textEditngController = TextEditingController();
  bool isLoading = false;

  // void postImage() async {
  //   StorageMethods().uploadImagetoStorage('posts', img!, true);
  // }

  @override
  void dispose() {
    super.dispose();
    _textEditngController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading:InkWell(
          onTap: () {
            setState(() {
              img = null;
              _textEditngController.clear();
              isLoading = false;
            });
          },
          child: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text("Add a Post"),
        actions: [
          TextButton(
            onPressed: () async {
              String res = "Some error occured";
              setState(() {
                isLoading = true;
              });
              try {
                res = await FirestoreMethods().uploadPost(
                  _textEditngController.text,
                  img!,
                  user.getUser.uid,
                  user.getUser.username,
                  user.getUser.photoUrl,
                );
              } catch (e) {
                res = e.toString();
              }

              if (res == "Success") {
                showSnackBar(res, context);
              }

              setState(() {
                isLoading = false;
              });
            },
            child: const Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          isLoading ? const LinearProgressIndicator(
            minHeight: 10,
          ) : Container(),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: boxDec(),
                  height: MediaQuery.of(context).size.width,
                  child: img == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () async {
                                Uint8List? temp =
                                    await pickImage(ImageSource.gallery);
                                setState(() {
                                  img = temp;
                                });
                              },
                              child: const Icon(
                                Icons.upload,
                                size: 100,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                Uint8List? temp =
                                    await pickImage(ImageSource.camera);
                                setState(() {
                                  img = temp;
                                });
                              },
                              child: const Icon(
                                Icons.camera_alt,
                                size: 100,
                              ),
                            ),
                          ],
                        )
                      : Row(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    maxLines: 10,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write a Caption...",
                    ),
                    controller: _textEditngController,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  boxDec() {
    if (img == null) {
      return const BoxDecoration(color: Colors.grey);
    } else {
      return BoxDecoration(
        image: DecorationImage(
          image: MemoryImage(img!),
        ),
      );
    }
  }
}
