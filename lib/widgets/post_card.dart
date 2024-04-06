import 'package:flutter/material.dart';
import 'package:instagram/models/user_model.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    final UserModel user =
        Provider.of<UserProvider>(context, listen: false).getUser;
    bool isLiked = widget.snap['likes'].contains(user.uid);
    // bool isLiked = true;

    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 4,
      ).copyWith(top: 5),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 15,
            ).copyWith(right: 0),
            child: Row(
              children: [
                ClipOval(
                  child: Image.network(
                    widget.snap['profImage'],
                    height: MediaQuery.of(context).size.width / 10,
                    width: MediaQuery.of(context).size.width / 10,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return Text('$error');
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.snap['username'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          children: [
                            TextButton(
                              child: Text("Delete"),
                              onPressed: () async {
                                if (user.uid == widget.snap['uid']) {
                                  Navigator.of(context).pop();
                                  showSnackBar("Deleted", context);
                                  await FirestoreMethods().deletePost(
                                      widget.snap['postId'],
                                      user.uid,
                                      widget.snap['postUrl']);
                                } else {
                                  Navigator.of(context).pop();
                                  showSnackBar(
                                      "The Post is not Your\'s", context);
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),

          //Image Section
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.width,
              minWidth: double.infinity,
              maxHeight: MediaQuery.of(context).size.width * 1.2,
            ),
            child: Image.network(
              widget.snap['postUrl'],
              fit: BoxFit.cover,
            ),
          ),

          //Interection Section
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  await FirestoreMethods().likePost(
                    widget.snap['postId'],
                    user.uid,
                    widget.snap['likes'],
                  );
                },
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border_rounded,
                  color: isLiked ? Colors.red : Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.message,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                child: Container(),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.bookmark_border,
                ),
              ),
            ],
          ),

          //Description and Comment
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("${widget.snap['likes'].length} Likes"),
                Row(
                  children: [
                    Text(
                      "${widget.snap['username']} ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.snap['caption']),
                  ],
                ),
                const Text(
                  "View all Comments",
                  style: TextStyle(color: secondaryColor),
                ),
                // Text(snap['datePublished']),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
