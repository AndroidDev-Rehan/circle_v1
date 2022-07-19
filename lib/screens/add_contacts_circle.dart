import 'package:circle/group_controller.dart';
import 'package:circle/screens/main_circle_modified.dart';
// import 'package:circle/request_controller.dart';

import 'package:circle/widgets/select_user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import '../request_controller.dart';
import 'chat_core/chat.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

///Add contacts and send requests for adding them in circle / group

class AddContactsScreen extends StatefulWidget {
  AddContactsScreen({Key? key, required this.room}) : super(key: key);
  final types.Room room;

  @override
  State<AddContactsScreen> createState() => _AddContactsScreenState();
}

class _AddContactsScreenState extends State<AddContactsScreen> {
  RequestsController requestsController = Get.put(
    RequestsController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text('Add Contacts'),
      ),
      body: StreamBuilder<List<types.User>>(
        stream: FirebaseChatCore.instance.users(),
        initialData: const [],
        builder: (context, AsyncSnapshot<List<types.User>> snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: const Text('No contacts'),
            );
          }

          print(snapshot.data!);

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];

              return SelectUserWidget(
                user: user,
                request: true,
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Obx(
                () =>
            (requestsController.loading.value)
              ? const SizedBox(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              :
            ElevatedButton(
                  child: const Text("Send Requests"),
                  onPressed: requestsController.requestsListUsers.isEmpty
                      ? null
                      : () async {
                          await requestsController.sendRequests(widget.room);
                          Get.to(const MainCircle());
                        },
                )
        ),
      ),
    );
  }

  @override
  void dispose(){
    requestsController.requestsListUsers.clear();
    requestsController.loading.value = false;
    print("dispose called");
    super.dispose();
  }
}
