import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';

class ProfilesView extends StatelessWidget {
  final snap;
  const ProfilesView({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.112,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Column(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        height: MediaQuery.of(context).size.width / 6.1,
                        width: MediaQuery.of(context).size.width / 6.1,
                        fit: BoxFit.cover,
                        imageUrl: snapshot.data!.docs[index].data()['photoUrl'],
                        // placeholder: (context, url) =>
                        //     const CircularProgressIndicator(
                        //   color: secondaryColor,
                        // ),
                        errorWidget: (context, url, error) => Text(error),
                      ),
                    ),
                    Text(snapshot.data!.docs[index].data()['username'])
                  ],
                ),
              ),
            );
          }),
    );
  }
}
