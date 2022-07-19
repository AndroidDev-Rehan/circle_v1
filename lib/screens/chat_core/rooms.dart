import 'package:circle/screens/users_for_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import '../login.dart';
import 'chat.dart';
import 'users.dart';
import 'util.dart';

///global roomMap for lastMesssage

Map<String, String> globalRoomMap = {};

class RoomsPage extends StatefulWidget {
  final bool secondVersion;
  const RoomsPage({this.secondVersion = false});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  bool _error = false;
  bool _initialized = false;
  User? _user;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container(
        width: 100,
        height: 100,
        color: Colors.red,
      );
    }

    if (!_initialized) {
      return Container(
        width: 100,
        height: 100,
        color: Colors.green,

      );
    }

    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: (!widget.secondVersion) ? AppBar(
        actions: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          //   child: ElevatedButton(
          //       onPressed: _user == null
          //           ? null
          //           : () {
          //         Navigator.of(context).push(
          //           MaterialPageRoute(
          //             fullscreenDialog: true,
          //             builder: (context) =>  UsersForGroupList(),
          //           ),
          //         );
          //       },
          //       child: Text("New Group"),
          //     style: ElevatedButton.styleFrom(
          //       primary: Colors.lightBlue
          //     ),
          //   ),
          // )


        ],
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: _user == null ? null : logout,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text('Circles'),
      ) : null,
      body: _user == null
          ? Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not authenticated'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            )
          : StreamBuilder<List<types.Room>>(
              stream: FirebaseChatCore.instance.rooms(),
              initialData: const [],
              builder: (context,AsyncSnapshot<List<types.Room>> snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(
                      bottom: 200,
                    ),
                    child: const Text('No Circles'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final room = snapshot.data![index];

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
                                    Text(room.name ?? 'no name', style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold),),
                                    const SizedBox(height: 10,),
                                    FutureBuilder(
                                      future: fetchLastMsg(room),
                                      builder: (BuildContext context,AsyncSnapshot snapshot){
                                        if(snapshot.connectionState == ConnectionState.waiting){
                                          return const Text("Loading", style: TextStyle(color: Colors.white),);
                                        }

                                        return Text(snapshot.data!, style: TextStyle(color: Colors.white),);

                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _user == null
            ? null
            : () {
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => const UsersPage(),
            ),
          );
        },
        child: const Icon(Icons.message_outlined,),
      ),
    );
  }

  Future<String> fetchLastMsg(types.Room room) async{
    try{
      final DocumentSnapshot<
          Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection("rooms").doc(room.id).get();
      final Map<String, dynamic> map = snapshot.data()!;
      globalRoomMap[room.id] = map["lastMsg"] ?? "chat ..." ;
      return map["lastMsg"] ?? "chat";
    }
    catch(e){
      return "Error";
    }
  }

  void initializeFlutterFire() async {
    try {
      // await Firebase.initializeApp();
      // await Firebase.initializeApp(
      //   options: DefaultFirebaseOptions.currentPlatform,
      // );
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if(mounted){
          setState(() {
            _user = user;
          });
        }
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        _error = true;
      });
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return LoginPage();
    }));
  }

  Widget _buildAvatar(types.Room room) {
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (u) => u.id != _user!.uid,
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

}
