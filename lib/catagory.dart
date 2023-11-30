import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rangers/component/home_widget.dart';

class Catagory extends StatefulWidget {
  final name;
  const Catagory({super.key, required this.name});

  @override
  State<Catagory> createState() => _CatagoryState();
}

class _CatagoryState extends State<Catagory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.name),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        alignment: Alignment.center,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.name)
                .collection("post")
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                return const Text("something is wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text(
                  "loading...",
                  style: TextStyle(color: Colors.brown),
                );
              }
              return ListView(
                children: snapshot.data!.docs
                    .map((document) => PostListItem(context, document))
                    .toList(),
              );
            })),
      ),
    );
  }
}
