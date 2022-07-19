import 'package:circle/group_controller.dart';

import 'package:circle/widgets/select_user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import 'chat_core/chat.dart';



/// select users for group

class UsersForGroupList extends StatefulWidget {
  UsersForGroupList({Key? key}) : super(key: key);

  @override
  State<UsersForGroupList> createState() => _UsersForGroupListState();
}

class _UsersForGroupListState extends State<UsersForGroupList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  initState(){
    GroupController.selectedUsers.clear();
    super.initState();
  }


  TextEditingController groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: const Text('Select Users'),
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Form(
            key: _formKey,
            child: TextFormField(
              controller: groupNameController,
              validator: (String? value){
                if(value == null || value.trim().isEmpty){
                  return "This field is required";
                }
                return null;
              },
              decoration: InputDecoration(
                label: Text("Circle Name"),
                isDense: true,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),


            ),
          ),
        ),
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

              print(snapshot.data!);

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final user = snapshot.data![index];

                  return SelectUserWidget(user: user);
                },
              );
            },
          ),
        ),
      ],
    ),
    bottomNavigationBar: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: ElevatedButton(
        child: Text("Create Circle"),
        onPressed: () async{
          await createGroup(context);
        },
      ),
    ),
  );

  Future<void> createGroup(BuildContext context) async{
    if(_formKey.currentState!.validate()){
      types.Room groupRoom = await FirebaseChatCore.instance.createGroupRoom(name: groupNameController.text, users: GroupController.selectedUsers, imageUrl: "https://thumbs.dreamstime.com/b/linear-group-icon-customer-service-outline-collection-thin-line-vector-isolated-white-background-138644548.jpg",metadata: {"group" : true});
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return ChatPage(room : groupRoom, groupChat: true,);
      }));

    }
}
}



