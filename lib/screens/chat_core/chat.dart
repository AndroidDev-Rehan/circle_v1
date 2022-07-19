import 'dart:io';

import 'package:circle/screens/chat_core/group_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    required this.room,
    this.groupChat = false,
    // required this.otherUser,
  });

  final bool groupChat;

  final types.Room room;
  // final types.User otherUser;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isAttachmentUploading = false;

  // String title = "";
  types.User? otherUser;

  @override
  void initState() {
    // for(int i=0; i<widget.room.users.length; i++){
    //   if(widget.room.users[i].id != FirebaseAuth.instance.currentUser!.uid){
    //     title = title + (widget.room.users[i].firstName ?? "user $i") + " ";
    //   }
    // }

    print(widget.room);
    print("last messages: ${widget.room.lastMessages}");

    if (!widget.groupChat) {
      for (int i = 0; i < widget.room.users.length; i++) {
        if (widget.room.users[i].id != FirebaseAuth.instance.currentUser!.uid) {
          otherUser = widget.room.users[i];
          break;
        }
      }
    }

    // FirebaseChatCore.instance.createGroupRoom(name: name, users: users);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: (!widget.groupChat)
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        otherUser!.imageUrl ??
                            "https://media.istockphoto.com/vectors/user-avatar-profile-icon-black-vector-illustration-vector-id1209654046?k=20&m=1209654046&s=612x612&w=0&h=Atw7VdjWG8KgyST8AXXJdmBkzn0lvgqyWod9vTb2XoE=",
                        width: 40,
                        height: 40,
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  Text(otherUser!.firstName!)
                  // Text(title),
                ],
              )
            :

            ///GROUP APP BAR
            InkWell(
              onTap: () {
                print("group name pressed");
                // Get.to(GroupInfoScreen(groupRoom: widget.room));
              },
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          "https://thumbs.dreamstime.com/b/linear-group-icon-customer-service-outline-collection-thin-line-vector-isolated-white-background-138644548.jpg",
                          width: 40,
                          height: 40,
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(child: Text(widget.room.name!, overflow: TextOverflow.clip,softWrap: false,)),

                    // Text(title),
                  ],
                ),
            ),
        leading: null,
        centerTitle: true,
        actions: [
          (widget.room.type == (types.RoomType.group)) ?
              InkWell(
                onTap: (){
                  Get.to(GroupInfoScreen(groupRoom: widget.room));
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.info_outline),
                ),
              ) : SizedBox()

          // PopupMenuButton<String>(
          //   icon: Icon(CupertinoIcons.ellipsis_vertical),
          //   // icon: Icon(Icons.add_circle_outline_outlined, size: 36, color: Colors.white.withOpacity(0.8),),
          //   // color: Color.fromRGBO(87, 87, 87, 0.5), // background color
          //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          //     PopupMenuItem<String>(
          //       value: "Group Info",
          //       onTap: () {
          //         print("hi");
          //         Get.to(()=> GroupInfoScreen(groupRoom: widget.room));
          //         // Navigator.pushReplacement(buildContext, MaterialPageRoute(builder: (context) {
          //         //   print("Hi there");
          //         //   return GroupInfoScreen(
          //         //     groupRoom: widget.room,
          //         //   );
          //         // }));
          //       },
          //       child: const Text(
          //         'Group Info',
          //         // style: TextStyle(color: Colors.red),
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
      body: StreamBuilder<types.Room>(
        initialData: widget.room,
        stream: FirebaseChatCore.instance.room(widget.room.id),
        builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
          initialData: const [],
          stream: FirebaseChatCore.instance.messages(snapshot.data!),
          builder: (context, snapshot) => Chat(
            showUserAvatars: true,
            showUserNames: true,
            isAttachmentUploading: _isAttachmentUploading,
            messages: snapshot.data ?? [],
            onAttachmentPressed: _handleAtachmentPressed,
            onMessageTap: _handleMessageTap,
            onPreviewDataFetched: _handlePreviewDataFetched,
            onSendPressed: _handleSendPressed,
            user: types.User(
              id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
            ),
          ),
        ),
      ),
    );
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.any,
    // );
    //
    // if (result != null && result.files.single.path != null) {
    //   _setAttachmentUploading(true);
    //   final name = result.files.single.name;
    //   final filePath = result.files.single.path!;
    //   final file = File(filePath);
    //
    //   try {
    //     final reference = FirebaseStorage.instance.ref(name);
    //     await reference.putFile(file);
    //     final uri = await reference.getDownloadURL();
    //
    //     final message = types.PartialFile(
    //       mimeType: lookupMimeType(filePath),
    //       name: name,
    //       size: result.files.single.size,
    //       uri: uri,
    //     );
    //
    //     FirebaseChatCore.instance.sendMessage(message, widget.room.id);
    //     _setAttachmentUploading(false);
    //
    //     await FirebaseFirestore.instance
    //         .collection("rooms")
    //         .doc(widget.room.id)
    //         .update({"lastMsg": "file"});
    //   } finally {
    //     _setAttachmentUploading(false);
    //   }
    // }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
        await FirebaseFirestore.instance
            .collection("rooms")
            .doc(widget.room.id)
            .update({"lastMsg": "photo"});
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final updatedMessage = message.copyWith(isLoading: false);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );
        }
      }

      await OpenFile.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) async {
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room.id,
    );

    await FirebaseFirestore.instance
        .collection("rooms")
        .doc(widget.room.id)
        .update({"lastMsg": message.text});
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }
}

