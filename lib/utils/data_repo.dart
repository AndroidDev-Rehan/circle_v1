import 'package:circle/screens/Create_Circle_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DataRepository {
  
  final CollectionReference collection = FirebaseFirestore.instance.collection('Circles');
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addCircle(Circle circle) {
    return collection.add(circle.toJson());
  }

  void updateCircle(Circle circle) async {
    await collection.doc(circle.refId).update(circle.toJson());
  }

  void deleteCircle(Circle circle) async {
    await collection.doc(circle.refId).delete();
  }
}
