
import 'package:circle/utils/data_repo.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'add_contacts_circle.dart';
import 'login.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


class Circle {
  String? name;
  String? description;
  String? status;
  String? contact;
  String? refId;

  Circle({this.refId,required this.name , required this.description,required this.status, required this.contact});
  factory Circle.fromJson(Map<String,dynamic> json) => _circleFromJson(json);
  Map<String,dynamic> toJson() => _circleToJson(this);

  factory Circle.fromSnapshot(DocumentSnapshot snapshot) {
    final newCircle = Circle.fromJson(snapshot.data() as Map<String,dynamic>);
    newCircle.refId = snapshot.reference.id;
    return newCircle;
  }

  @override
  String toString() => 'Circle<$name>';
}

Circle _circleFromJson(Map<String,dynamic> json) {
  return Circle(name: json['name']  ?? "",
                description: json['description']  ?? "",
                status: json['status']  ?? "",
                contact: json['contact']  ?? "");
}
Map<String,dynamic> _circleToJson(Circle instance) =>
    <String,dynamic> {
       'name': instance.name,
       'description': instance.description,
       'status': instance.status,
        'contact': instance.contact,
    };

class CreateCirclePage extends StatefulWidget {
  const CreateCirclePage({Key? key}) : super(key: key);
  @override
  State<CreateCirclePage> createState() => CreateCircleState();
}

class CreateCircleState extends State<CreateCirclePage>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loading = false;


  final db = FirebaseFirestore.instance;
  final DataRepository repo = DataRepository();
  final textControllerName = TextEditingController();
  final textControllerDescription = TextEditingController();
  final textControllerStatus = TextEditingController();
  final textControllerContact = TextEditingController();


  // Future<void> createCircle() async {
  //
  //   repo.addCircle(Circle(name: textControllerName.text,
  //   description: textControllerDescription.text,
  //   status: textControllerDescription.text,
  //   contact: textControllerContact.text));
  //   Widget okButton = FlatButton(
  //     child: const Text("OK"),
  //     onPressed: () {
  //       Navigator.of(context, rootNavigator: true).pop('dialog');
  //       Navigator.of(context, rootNavigator: true).pop();
  //     },
  //   );
  //
  //   AlertDialog dialog =  AlertDialog(
  //     title: const Text("Circle Added"),
  //     actions: [okButton],
  //   );
  //   showDialog(context: context,
  //     builder: (BuildContext build) {
  //        return dialog;
  //     }
  //   );
  //
  // }

  @override
  Widget build(BuildContext context ) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Create Circle"),
          leading: IconButton(icon:const Icon(Icons.arrow_back),
          onPressed:()=> Navigator.pop(context,false),
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 10),
                          child: TextFormField(
                            controller: textControllerName,
                            decoration: const InputDecoration(
                              labelText: "Name:",
                              hintText: 'Name of Circle'
                            ),
                            validator: (String? value){
                              if(value == null || value.trim().isEmpty){
                                return "Name of Circle is required";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 10),
                          child: TextFormField(
                            controller: textControllerDescription,
                            decoration: const InputDecoration(
                              labelText: "Description",
                              hintText: " Description of Circle"
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 10),
                          child: TextFormField(
                            controller: textControllerStatus,
                            decoration: const InputDecoration(
                              hintText: "Temporary or Permanent",
                              labelText: "Status",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 10),
                          child: TextFormField(
                            controller: textControllerContact,
                            decoration: const InputDecoration(
                              labelText: "Contact",
                              hintText: "Primary Contact Name"
                            ),
                          ),
                        ),
                      loading ? const SizedBox(
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )  : ElevatedButton(
                          onPressed: () async{

                            await createGroup(context);

                        }, child: const Text("Submit"))
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createGroup(BuildContext context) async{
    if(_formKey.currentState!.validate()){

      setState((){
        loading = true;
      });

     try {
        types.Room groupRoom = await FirebaseChatCore.instance.createGroupRoom(
            name: textControllerName.text,
            users: <types.User>[],
            imageUrl:
                "https://thumbs.dreamstime.com/b/linear-group-icon-customer-service-outline-collection-thin-line-vector-isolated-white-background-138644548.jpg",
            metadata: {"group": true});
        print(groupRoom.id);
        Get.off(()=>AddContactsScreen(
          room: groupRoom,
        ));
      }
      catch(e){
       Get.snackbar("Error", e.toString());
      }

      if(mounted){
        setState(() {
          loading = false;
        });
      }

    }
  }

}