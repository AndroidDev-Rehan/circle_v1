import 'package:flutter/material.dart';
import 'package:circle/utils/data_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:circle/screens/Create_Circle_screen.dart';

class viewCircle extends StatefulWidget {
  const viewCircle({ Key? key }) : super(key: key);

  @override
  State<viewCircle> createState() => _viewCircleState();
}

class _viewCircleState extends State<viewCircle> {
  final DataRepository repo = DataRepository();
  void getCircles() {
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final circle = Circle.fromSnapshot(snapshot);
    print(circle.name);
    print(circle.contact);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:<Widget> [
        Row( children: [
          const Text("Name:",
              style:
              TextStyle(fontWeight: FontWeight.bold)
          ),
    Text(circle.name.toString(),style:
    const TextStyle(
        backgroundColor: Colors.red
        , fontWeight: FontWeight.bold)),
       ],
        ),
        ListTile(title: Text(circle.description.toString()),
            subtitle: Text(circle.status.toString())),
      ],
    );
  }

  final dynamic data = DataRepository().getStream();
  @override
  Widget build(BuildContext context) {
    return buildHome(context);
  }

  Widget buildHome(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Circles"),
      ),

      body:ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: double.maxFinite),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: StreamBuilder<QuerySnapshot>(
              stream: data,
              builder: (context, snapshot){
                if (!snapshot.hasData ) return const Center(child: CircularProgressIndicator());
                  return _buildList(context, snapshot.data?.docs ?? []);
                }),
        ),
      ),
      );
  }
  // Widget build(BuildContext context) {
  //  return StreamBuilder<QuerySnapshot>(
  //    stream: repo.getStream(),
  //    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //      if (!snapshot.hasData) {
  //        return Center(child: CircularProgressIndicator());
  //      }else {
  //        return ListView(
  //          children: snapshot.data?.docs.map((document){
  //          return ListTile(
  //            title: Text(document['title'].toString()),
  //            subtitle: Text(document['contact'].toString()),
  //          );
  //        }).toList()
  //        );;
  //      }
  //    }
  // );
}