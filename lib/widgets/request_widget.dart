import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class RequestWidget extends StatefulWidget {
  final types.Room room;
  const RequestWidget({Key? key, required this.room,}) : super(key: key);

  @override
  State<RequestWidget> createState() => _RequestWidgetState();
}

class _RequestWidgetState extends State<RequestWidget> {

  bool loading = false;
  bool dismissed = false;

  @override
  Widget build(BuildContext context) {
     const double size = 50;

    return dismissed ? const SizedBox() : loading ? const SizedBox(height: 40, child: Center(child: CircularProgressIndicator(),),) : Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        title: Text(widget.room.name!, style: const TextStyle(fontWeight: FontWeight.bold),),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children:  [
            InkWell(
                onTap: accept,
                child: const Icon(Icons.check_circle, color: Colors.green, size: size,)),
            const SizedBox(width: 5,),
            InkWell(
                onTap: reject,
                child: Icon(Icons.remove_circle, color: Colors.red, size: size,))
          ],
        ),
      ),
    );
  }

  Future<void> reject() async {
    setState((){
      loading = true;
    });

    try{
      List<String> list = [];
      list.add(FirebaseAuth.instance.currentUser!.uid);

      FirebaseFirestore.instance
          .collection("rooms")
          .doc(widget.room.id)
          .update({"requests": FieldValue.arrayRemove(list)});

      Get.snackbar("Success","Invite Rejected");

    }
    catch(e){
      print(e);
    }

    setState((){
      loading = false;
      dismissed = true;
    });

  }

  Future<void> accept()async{

    final List<String> userIds = widget.room.users.map((types.User user) => user.id).toList();
    userIds.add(FirebaseAuth.instance.currentUser!.uid);

    setState((){
      loading = true;
    });

    try {

      List<String> list = [];
      list.add(FirebaseAuth.instance.currentUser!.uid);

      FirebaseFirestore.instance
          .collection("rooms")
          .doc(widget.room.id)
          .update({"requests": FieldValue.arrayRemove(list)});

      await FirebaseFirestore.instance.collection("rooms")
          .doc(widget.room.id)
          .update({"userIds": userIds});

      Get.snackbar("Success","Invite Accepted");


    }
    catch(e){
      print(e);
    }

    setState((){
      loading = false;
      dismissed = true;
    });

  }

}
