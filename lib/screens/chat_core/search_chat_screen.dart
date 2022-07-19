import 'package:circle/widgets/single_chat_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';


class SearchChatScreen extends StatefulWidget {

  const SearchChatScreen({Key? key,}) : super(key: key);

  @override
  State<SearchChatScreen> createState() => _SearchChatScreenState();
}

class _SearchChatScreenState extends State<SearchChatScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Column(
          children: [
            SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextFormField(
                onChanged: (value){
                  setState((){});
                },
                controller: searchController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                    ),
                    label: Text("Search", style: TextStyle(color: Colors.white),),
                    isDense: true
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: StreamBuilder<List<types.Room>>(
                stream: FirebaseChatCore.instance.rooms(),
                initialData: const [],
                builder: (context, AsyncSnapshot<List<types.Room>> snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(
                        bottom: 200,
                      ),
                      child: const Text('No circles'),
                    );
                  }

                  print(snapshot.data!);

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context,int index) {
                      final types.Room room = snapshot.data![index];

                      String? otherUserName;

                      if (room.type==types.RoomType.direct) {
                        for (int i=0; i<room.users.length; i++){
                          if(room.users[i].id != FirebaseAuth.instance.currentUser!.uid){
                            otherUserName = ("${room.users[i].firstName} ${room.users[i].lastName}");
                          }
                        }
                      }

                      if (
                      searchController.text.isEmpty ||
                      (room.name?.toLowerCase().startsWith(RegExp(searchController.text.toLowerCase().trim())) ?? false) ||
                      (otherUserName?.toLowerCase().startsWith(RegExp(searchController.text.toLowerCase().trim())) ?? false)


                      ) {
                        return SingleChatTile(room: room);
                      }
                      return SizedBox();

                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );

}
