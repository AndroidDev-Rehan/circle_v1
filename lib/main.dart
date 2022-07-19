import 'package:circle/screens/login.dart';
import 'package:circle/screens/main_circle_modified.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  // void login() {}

  // Future<FirebaseApp> _initFireBase() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   FirebaseApp firebaseApp = await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //   return firebaseApp;
  // }

  final TextEditingController editingController = TextEditingController();
  final TextEditingController editingController1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      title: 'Circle',
      home:
          (FirebaseAuth.instance.currentUser!=null) ?
      const MainCircle() : LoginPage()
      // Center(
      //   child: Scaffold(
      //     appBar: AppBar(
      //       title: const Text('Circle'),
      //     ),
      //     body: LoginPage()
      //     // FutureBuilder(
      //     //   future: _initFireBase(),
      //     //   builder: (context, snapshot) {
      //     //     if (snapshot.connectionState == ConnectionState.done) {
      //     //       return Column(
      //     //         children: const [
      //     //           Text('Login'),
      //     //           LoginPage(),
      //     //         ],
      //     //       );
      //     //     }
      //     //     return const Center(
      //     //       child: CircularProgressIndicator(),
      //     //     );
      //     //   },
      //     // )
      //
      //   ),
      // ),
    );
  }
}
