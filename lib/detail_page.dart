import 'package:flutter/material.dart';
import 'package:rangers/component/home_widget.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const DetailPage({super.key, required this.data});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.data['title']),
      ),
      body: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 245, 236, 223),
            borderRadius: BorderRadius.circular(25)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImagePost(widget.data['ImageUrl']),
            HeadText(widget.data['title']),
            Text(widget.data['description']),
            UserInfo(widget.data['userid'])
          ],
        ),
      ),
    );
  }
}
