import 'package:circle/group_controller.dart';
import 'package:circle/request_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../screens/chat_core/chat.dart';
import '../screens/chat_core/util.dart';



class SelectUserWidget extends StatefulWidget {
  final types.User user;
  final bool request;
  const SelectUserWidget({Key? key, required this.user, this.request = false}) : super(key: key);

  @override
  State<SelectUserWidget> createState() => _SelectUserWidgetState();
}

class _SelectUserWidgetState extends State<SelectUserWidget> {

  RequestsController? requestsController;

  @override
  void initState(){
    if(widget.request){
      requestsController = Get.find<RequestsController>();
    }

    super.initState();
  }

  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(widget.request){
          _addToRequestController(widget.user);
        }
        else {
          _addToGroupController(widget.user, context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          children: [
            _buildAvatar(widget.user),
            Text(getUserName(widget.user)),
            Spacer(),
            Icon( selected ? Icons.check_circle   : Icons.circle_outlined, color: Colors.purple,),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(types.User user) {
    final color = getUserAvatarNameColor(user);
    final hasImage = user.imageUrl != null;
    final name = getUserName(user);

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(user.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
          name.isEmpty ? '' : name[0].toUpperCase(),
          style: const TextStyle(color: Colors.white),
        )
            : null,
      ),
    );
  }

  void _addToGroupController(types.User otherUser, BuildContext context) {

    if(selected){
      GroupController.selectedUsers.removeWhere((types.User listUser) => listUser.id == widget.user.id);
    }
    else{
      GroupController.selectedUsers.add(widget.user);
    }

      setState((){
      selected = !selected;
    });

  }

  void _addToRequestController(types.User otherUser,) {

    if(selected){
      requestsController!.requestsListUsers.removeWhere((types.User listUser) => listUser.id == widget.user.id);
    }
    else{
      requestsController!.requestsListUsers.add(widget.user);
    }

    setState((){
      selected = !selected;
    });

    for (int i =0; i<requestsController!.requestsListUsers.length; i++){
      print(requestsController!.requestsListUsers[i].firstName);
    }

    print("\n\n");
  }



}
