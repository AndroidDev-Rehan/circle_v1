import 'package:circle/screens/Create_Circle_screen.dart';
import 'package:circle/screens/chat_core/search_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import '../users_for_group.dart';
import 'chat.dart';
import 'util.dart';

class UsersPage extends StatelessWidget {
  const UsersPage();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: const Text('Users'),
          actions: [
            InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(Icons.search),
                ),
              onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                    return SearchUsersScreen();
                  }));
              },

            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton(
                onPressed:  () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>  const CreateCirclePage(),
                    ),
                  );
                },
                child: const Text("Create a Circle"),
                style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue
                ),
              ),
            ),
            const SizedBox(height: 20,),
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

                      return GestureDetector(
                        onTap: () {
                          _handlePressed(user, context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              _buildAvatar(user),
                              Text(getUserName(user)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );

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

  void _handlePressed(types.User otherUser, BuildContext context) async {
    final navigator = Navigator.of(context);
    print("other user: $otherUser");
    final room = await FirebaseChatCore.instance.createRoom(otherUser);

    navigator.pop();
    await navigator.push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          room: room,
        ),
      ),
    );
  }
}
