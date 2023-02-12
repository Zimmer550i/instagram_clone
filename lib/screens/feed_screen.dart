import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/post_card.dart';
import 'package:instagram/widgets/profiles_view.dart';
import 'package:instagram/utils/my_icons.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height*0.1,
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/Instagram_logo.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(My.messenger),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length+1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ProfilesView(
                  snap: snapshot,
                );
              } else {
                return PostCard(
                  snap: snapshot.data!.docs[index - 1].data(),
                );
              }
            },
          );
        },
      ),
    );
  }
}
