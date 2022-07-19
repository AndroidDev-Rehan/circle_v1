import 'package:circle/group_controller.dart';
import 'package:circle/screens/chat_core/group_info.dart';

import 'package:circle/widgets/select_user_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';

class AddMembersScreen extends StatefulWidget {
  const AddMembersScreen({Key? key, required this.groupRoom}) : super(key: key);
  final types.Room groupRoom;

  @override
  State<AddMembersScreen> createState() => _AddMembersScreenState();
}

class _AddMembersScreenState extends State<AddMembersScreen> {

  @override
  initState(){
    GroupController.selectedUsers.clear();
    super.initState();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: const Text('Select Users'),
    ),
    body: Column(
      children: [
        Expanded(
          child: StreamBuilder<List<types.User>>(
            stream: FirebaseChatCore.instance.users(),
            initialData: const [],
            builder: (context, AsyncSnapshot<List<types.User>> snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                    bottom: 200,
                  ),
                  child: const Text('No users'),
                );
              }

              // print(snapshot.data!);

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final user = snapshot.data![index];

                  if(widget.groupRoom.users.contains(user)){
                    return const SizedBox();
                  }

                  return SelectUserWidget(user: user);
                },
              );
            },
          ),
        ),
      ],
    ),
    bottomNavigationBar: loading ? const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(height: 50,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ) : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
      child: ElevatedButton(
        child: Text("Add to Circle".toUpperCase()),
        onPressed: () async{
          await addMembers();
          Get.off(
            GroupInfoScreen(groupRoom: widget.groupRoom)
          );
        },
      ),
    ),
  );

  Future<void> addMembers() async{

    widget.groupRoom.users.addAll(GroupController.selectedUsers);

    List<String> userIds = widget.groupRoom.users.map((types.User user) => user.id).toList();

    setState((){
      loading = true;
    });

    try {
      // await FirebaseFirestore.instance.collection("rooms")
      //     .doc(widget.groupRoom.id)
      //     .update({"users": userIds});
      await FirebaseFirestore.instance.collection("rooms")
          .doc(widget.groupRoom.id)
          .update({"userIds": userIds});

    }
    catch(e){
      print(e);
    }

    setState((){
      loading = false;
    });


  }



}



