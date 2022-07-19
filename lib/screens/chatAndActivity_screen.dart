import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChatAndActivityScreen extends StatefulWidget {
  const ChatAndActivityScreen({Key? key}) : super(key: key);
  @override
  _ChatAndActivityScreenState createState() => _ChatAndActivityScreenState();
}

class _ChatAndActivityScreenState extends State<ChatAndActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Hello'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget> [
          Container(
            height: 50,
            color: Colors.amber[600],
            child: const Center(child: Text("Arbi")),
          ),
          Container(
            height: 50,
            color: Colors.amber[600],
            child: const Center(child: Text("Arbi")),
          ),
          Container(
            height: 50,
            color: Colors.amber[600],
            child: const Center(child: Text("Arbi")),
          )
        ],
      )
    );
  }
}