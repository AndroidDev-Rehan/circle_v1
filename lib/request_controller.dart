import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


class RequestsController extends GetxController{
  RxList<types.User> requestsListUsers = <types.User>[].obs;
  Rx<bool> loading =false.obs;


  ///adding room ids in requests collection and userid sub document
  Future<void> sendRequests(types.Room room) async{

    loading.value = true;

    try{

      final List<String> usersIdList = requestsListUsers.map((types.User user) => user.id).toList();

      FirebaseFirestore.instance.collection("rooms").doc(room.id).update(
        {
          "requests" : usersIdList
        }
      );

      // for (int i=0; i<requestsListUsers.length; i++) {
      //   FirebaseFirestore.instance.collection(StringConstants.circleRequestsCollection).doc(requestsListUsers[i].id).update(
      //     {
      //       room.id : true
      //     }
      //   );
      // }

      Get.snackbar("Success", "Requests Sent");

    }
    catch(e){
      Get.snackbar("error", e.toString());

    }

    loading.value = false;
    requestsListUsers.clear();
  }

  @override
  void dispose(){

    loading.value = false;
    requestsListUsers.clear();
    super.dispose();
  }
}
