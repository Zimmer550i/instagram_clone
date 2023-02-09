import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  var isLiked = false;

  @override
  Widget build(BuildContext context) {
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
                  child: CachedNetworkImage(
                    height: MediaQuery.of(context).size.width/10,
                    width: MediaQuery.of(context).size.width/10,
                    fit: BoxFit.cover,
                    imageUrl: widget.snap['profImage'],
                    // placeholder: (context, url) => const CircularProgressIndicator(color: primaryColor,),
                    errorWidget: (context, url, error) => Text(error),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.snap['username'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showSnackBar("Ar koto chas?", context);
                  },
                  icon: Icon(Icons.more_vert),
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
            child: CachedNetworkImage(  
              imageUrl: widget.snap['postUrl'],
              fit: BoxFit.cover,
            )
          ),

          //Interection Section
          Container(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isLiked = isLiked ? false : true;
                    });
                  },
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border_rounded,
                    color: Colors.red,
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
          ),

          //Description and Comment
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("${widget.snap['likes'].length} Likes"),
                Row(
                  children: [
                    Text(
                      "${widget.snap['username']} ",
                      style: TextStyle(fontWeight: FontWeight.bold),
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
