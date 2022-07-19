import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import 'chat.dart';
import 'util.dart';

class SearchUsersScreen extends StatefulWidget {
  const SearchUsersScreen({Key? key}) : super(key: key);

  @override
  State<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextFormField(
                onChanged: (value){
                  setState((){});
                },
                controller: searchController,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    labelText: "Search Users",
                  isDense: true
                ),
              ),
            ),
            const SizedBox(height: 10,),
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

                      if (searchController.text.isEmpty || user.firstName!.toLowerCase().startsWith(RegExp(searchController.text.toLowerCase().trim()))) {
                        return GestureDetector(
                          onTap: () {
                            _handlePressed(user, context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
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

