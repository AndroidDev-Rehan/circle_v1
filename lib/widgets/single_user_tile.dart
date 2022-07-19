import 'package:circle/screens/chat_core/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class SingleUserTile extends StatefulWidget {
  const SingleUserTile({Key? key, required this.user, required this.groupRoom}) : super(key: key);

  final types.User user;
  final types.Room groupRoom;

  @override
  State<SingleUserTile> createState() => _SingleUserTileState();
}

class _SingleUserTileState extends State<SingleUserTile> {

  bool loading=false;
  bool deleted = false;

  @override
  Widget build(BuildContext context) {
    return deleted ? SizedBox() : Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          _buildAvatar(widget.user),
          Text(getUserName(widget.user)),
          Spacer(),
          !loading ?
          InkWell(
            onTap: () async{
              await removeMember();
            },
              child: Icon(Icons.delete_outline)
          ) : SizedBox(
            height: 30,
            width: 30,
            child: Center(child: CircularProgressIndicator()),
          )

        ],
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

  Future<void> removeMember() async{

    widget.groupRoom.users.removeWhere((types.User user) => (user.id == widget.user.id));
    List<String> userIds = widget.groupRoom.users.map((types.User user) => user.id).toList();

    setState((){
      loading = true;
    });

    try {
      await FirebaseFirestore.instance.collection("rooms")
          .doc(widget.groupRoom.id)
          .update({"userIds": userIds});
      deleted = true;
    }
    catch(e){
      deleted = false;
      print(e);
    }

    setState((){
      loading = false;
    });


  }


}
