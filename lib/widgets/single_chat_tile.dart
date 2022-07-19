import 'package:circle/screens/chat_core/rooms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../screens/chat_core/chat.dart';
import '../screens/chat_core/util.dart';



class SingleChatTile extends StatelessWidget {
  const SingleChatTile({Key? key, required this.room}) : super(key: key);

  final types.Room room;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatPage(
              room: room,
              groupChat: room.type== types.RoomType.group,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildAvatar(room),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(room.name ?? 'no name', style: const TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold),),
                    const SizedBox(height: 10,),
                    Text(globalRoomMap[room.id] ?? "null", style: const TextStyle(color: Colors.white),),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(types.Room room) {
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
              (u) => u.id != FirebaseAuth.instance.currentUser!.uid,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        // Do nothing if other user is not found.
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
        radius: 30,
        child: !hasImage
            ? Text(
          name.isEmpty ? '' : name[0].toUpperCase(),
          style: const TextStyle(color: Colors.white),
        )
            : null,
      ),
    );
  }

  Future<String> fetchLastMsg(types.Room room) async{
    try{
      final DocumentSnapshot<
          Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection("rooms").doc(room.id).get();
      final Map<String, dynamic> map = snapshot.data()!;
      return map["lastMsg"] ?? "chat";
    }
    catch(e){
      return "Error";
    }
  }



}
