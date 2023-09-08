import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Text('neko'),
        ],
      ),
    );
  }
}
