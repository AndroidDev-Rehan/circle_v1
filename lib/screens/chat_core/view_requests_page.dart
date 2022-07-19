import 'package:circle/utils/constants.dart';
import 'package:circle/widgets/request_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';


class ViewRequestsPage extends StatelessWidget {
  const ViewRequestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Circle Invites"),
      ),
      backgroundColor: Colors.lightBlue,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          Container(
              padding: EdgeInsets.all(16),
              child: Text("Accept Invite to Join Circles",style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600,fontSize: 20),),
            color: Colors.transparent,
          ),
          SizedBox(height: 20,),
          Expanded(
            child: FutureBuilder(
              future: fetchRequests(),
              builder: (BuildContext context, AsyncSnapshot<List<types.Room>> snapshot){
                if(snapshot.connectionState == ConnectionState.waiting || (!(snapshot.hasData))){
                  return const Center(child: CircularProgressIndicator(),);
                }

                List<types.Room> rooms = snapshot.data!;


                return ListView.builder(
                  itemCount: rooms.length,
                    itemBuilder: (context,index){
                    return RequestWidget(room: rooms[index]);
                    }
                );
              },
            ),
          ),
        ],
      ),
    );

  }

  Future<List<types.Room>> fetchRequests() async{

    print("into fetch requests");

    List<types.Room> roomsList = <types.Room>[];

    QuerySnapshot<Map<String,dynamic>> allRoomsCollection = await FirebaseFirestore.instance.collection("rooms").get();

    for (int i=0; i<allRoomsCollection.docs.length; i++){


      final Map<String,dynamic> map  = allRoomsCollection.docs[i].data();
      final String id = allRoomsCollection.docs[i].id;

      if(map["requests"] == null){
        print("continuing $i, id: $id");
        continue;
      }

      print("not continuing $i, id: $id");

      // print((map['requests']).runtimeType);

      final List requests = map["requests"] ?? [];

      print("passed $i");
      print(requests);
      // print(object)

      if(requests.contains(FirebaseAuth.instance.currentUser!.uid)){
        print("trying");
        print(map);
        roomsList.add( await FirebaseChatCore.instance.room(allRoomsCollection.docs[i].id).first );
      }

      print("loop $i ended");


    }

    print("length of all room docs is ${allRoomsCollection.docs.length}");
    print("length of roomslist is ${roomsList.length}");

    return roomsList;
  }


}

// types.Room roomFromMap(Map<String,dynamic> json, String id){
//
//   // return types.Room(
//   //   createdAt: json['createdAt'] as int?,
//   //   id: id,
//   //   imageUrl: json['imageUrl'] as String?,
//   //   lastMessages: (json['lastMessages'] as List<dynamic>?)
//   //       ?.map((e) => types.Message.fromJson(e as Map<String, dynamic>))
//   //       .toList(),
//   //   metadata: json['metadata'] as Map<String, dynamic>?,
//   //   name: json['name'] as String?,
//   //   type: checkRoomType(json['name']),
//   //   updatedAt: json['updatedAt'] as int?,
//   //   users: (json['users'] as List<dynamic>)
//   //       .map((e) => types.User.fromJson(e as Map<String, dynamic>))
//   //       .toList(),
//   // );
//
//
// }
//
// types.User userFromMap(Map<String,dynamic> json){
// return types.User(
//   createdAt: null,
//   firstName: json['firstName'] as String?,
//   id: ,
//   imageUrl: json['imageUrl'] as String?,
//   lastName: json['lastName'] as String?,
//   lastSeen: null,
//   metadata: null,
//   role: null,
//   updatedAt: null,
// );
//
// }

// types.RoomType checkRoomType(String x){
//   if(x=="group"){
//     return types.RoomType.group;
//   }
//   else{
//     return types.RoomType.direct;
//   }
// }