import 'package:circle/screens/Create_Circle_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class User {
  String? userName;
  String? refId;

  User({this.refId,required this.userName});
  factory User.fromJson(Map<String,dynamic> json) => _userFromJson(json);
  Map<String,dynamic> toJson() => _userToJson(this);

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final newUser = User.fromJson(snapshot.data() as Map<String,dynamic>);
    newUser.refId = snapshot.reference.id;
    return newUser;
  }

  @override
  String toString() => 'Circle<$userName>';
}
User _userFromJson(Map<String,dynamic> json) {
  return User(userName: json['name']  ?? "");
}
Map<String,dynamic> _userToJson(User instance) =>
    <String,dynamic> {
      'userName': instance.userName,
    };
class DataRepository {

  final CollectionReference collection = FirebaseFirestore.instance.collection('users');
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  void updateUser(User user) async {
    await collection.doc(user.refId).update(user.toJson());
  }

  // Stream<List<User>> getUsers() {
  //     var collection = FirebaseFirestore.instance.collection('users');
  //     collection.orderBy(true)
  //     .snapshots()
  //     final users = User.fromJson(collection.orderBy(true).snapshots() as Map<String,dynamic>);
  // }

}