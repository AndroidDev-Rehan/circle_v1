import 'package:circle/screens/create_Account.dart';
import 'package:circle/screens/firebase_login.dart';
import 'package:flutter/material.dart';
import 'package:circle/screens/main_circle.dart';

import 'main_circle_modified.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key:key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _texFieldController = TextEditingController();
  final TextEditingController _texFieldController2 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }



  // void login() {
  //
  //
  // }
  //
  // void signup() {
  //
  // }

  void showAlert(BuildContext context, String content) {
    Widget okButton = FlatButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    AlertDialog dialog = AlertDialog(
        title: const Text('Alert Dialog'),
        actions: [ okButton,],
        content: SingleChildScrollView(
        child: ListBody(
        children: <Widget>[
          Text('Error: $content'),
          ],
        ),
      )
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
        return dialog;
    },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Text("Login"),
            SizedBox(height: 10,),
            Image.asset("assets/images/Circle.jpg", width: 400, height: 80),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 9, vertical: 16),
              child: TextFormField(
                controller: _texFieldController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your username',
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 9, vertical: 16),
              child: TextFormField(
                controller: _texFieldController2,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your password',
                  hintText: 'password must be  ',
                ),
                obscureText: true,
              ),
            ),
            const SizedBox(
              width: 300,
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 300,
                child:
                ElevatedButton(
                  onPressed: () {

                    Future<String?> user  = FireAuth.signInUsingEmailPassword(email: _texFieldController.text, password: _texFieldController2.text, context:context);
                    user.then((value) => {
                      if(value == null)
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder:(context) => const MainCircle()),
                          ),
                        }else {
                        showAlert(context,value),
                      }
                    },onError: (err){
                      showAlert(context,err);
                    });
                  },
                  child: const Text("Sign in"),
                ),
              ),
            ),
            const Text(
              "Don't have an account Sign up now!",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    FireAuth.registerUsingEmailPassword(name: "", email: _texFieldController.text, password: _texFieldController2.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder:(context) => const CreateAccount()),
                    );
                  },
                  child: const Text('Sign up'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
