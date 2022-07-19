import 'package:circle/screens/chat_core/add_group_members.dart';
import 'package:circle/widgets/single_user_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import '../main_circle_modified.dart';

class GroupInfoScreen extends StatefulWidget {

  final types.Room groupRoom;

  const GroupInfoScreen({Key? key, required this.groupRoom}) : super(key: key);

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  bool loading = false;

  TextEditingController groupNameController = TextEditingController();

  @override
  initState(){

    groupNameController.text = widget.groupRoom.name!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Circle Info"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  widget.groupRoom.imageUrl ??
                      "https://media.istockphoto.com/vectors/user-avatar-profile-icon-black-vector-illustration-vector-id1209654046?k=20&m=1209654046&s=612x612&w=0&h=Atw7VdjWG8KgyST8AXXJdmBkzn0lvgqyWod9vTb2XoE=",
                  width: 100,
                  height: 100,
                )),
            SizedBox(height: 10,),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: groupNameController,
                validator: (String? value){
                  if(value == null || value.trim().isEmpty){
                    return "Circle name can't be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: Text("Circle Name", style: TextStyle(fontWeight: FontWeight.normal),),
                  isDense: true,
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)



              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: (){
                  Get.to(AddMembersScreen(groupRoom: widget.groupRoom));
                },
                child: Text("Add Members")

            ),
            SizedBox(height: 20, ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Text("${widget.groupRoom.users.length} Participants", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            SizedBox(height: 10, ),

            // Text(groupRoom.name!,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            Expanded(
                child: ListView.builder(
                itemCount: widget.groupRoom.users.length,
                itemBuilder: (context,index){
                  types.User user = widget.groupRoom.users[index];
                  return SingleUserTile(user: user, groupRoom: widget.groupRoom);
                }

            )),
          ],
        ),
      ),
      bottomNavigationBar: loading ? const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: SizedBox(height: 50,
         child: Center(
           child: CircularProgressIndicator(),
         ),
        ),
      ): Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
        child: ElevatedButton(
          child: const Text("Save Info"),
          onPressed: () async{
            if(_formKey.currentState!.validate()){
                    print("hello");
                    await _updateGroupName();
                    Get.offAll(
                      const MainCircle(),
                    );
                  }
                },
        ),
      ),
    );
  }


  Future<void> _updateGroupName() async{

    setState((){
      loading=true;
    });

    await FirebaseFirestore.instance.collection("rooms").doc(widget.groupRoom.id).update({
      "name" : groupNameController.text
    });

    setState((){
      loading=false;
    });

  }
}


