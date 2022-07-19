import 'package:circle/screens/main_circle_modified.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:circle/screens/firebase_login.dart';
import 'package:circle/screens/main_circle.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);
  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  // String? _email;
  TextEditingController? _firstNameController;
  FocusNode? _focusNode;
  TextEditingController? _lastNameController;
  TextEditingController? _passwordController;
  bool _registering = false;
  TextEditingController? _usernameController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up"),
      ),
      body: _registering ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          children: <Widget>[
            Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Image.asset("assets/images/Circle.jpg",
                        width: 400, height: 80),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 9, vertical: 16),
                      child: TextFormField(
                        validator: (String? value){
                          if(value == null || value.trim().isEmpty){
                            return "This field is required";
                          }
                          return null;
                        },
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'First Name',
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 9, vertical: 16),
                      child: TextFormField(
                        validator: (String? value){
                          if(value == null || value.trim().isEmpty){
                            return "This field is required";
                          }
                          return null;
                        },

                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Last Name',
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 9, vertical: 16),
                      child: TextFormField(
                        validator: (String? value){
                          if(value == null || value.trim().isEmpty){
                            return "This field is required";
                          }
                          return null;
                        },

                        controller: _usernameController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 9, vertical: 16),
                      child: TextFormField(
                        validator: (String? value){
                          if(value == null || value.trim().isEmpty){
                            return "This field is required";
                          }
                          return null;
                        },

                        controller: _passwordController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Password',
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
                        child: ElevatedButton(
                          onPressed: _registering ? null : _register,
                            child: const Text('Sign up'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _register() async {
    FocusScope.of(context).unfocus();

    if(_formKey.currentState!.validate()){
      setState(() {
        _registering = true;
      });

      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _usernameController!.text,
          password: _passwordController!.text,
        );
        await FirebaseChatCore.instance.createUserInFirestore(
          types.User(
            firstName: _firstNameController!.text,
            id: credential.user!.uid,
            imageUrl:
                'https://i.pravatar.cc/300?u=${_usernameController!.text}',
            lastName: _lastNameController!.text,
          ),
        );

        if (!mounted) return;
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MainCircle();
        }));
      } catch (e) {
        setState(() {
          _registering = false;
        });

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
            content: Text(
              e.toString(),
            ),
            title: const Text('Error'),
          ),
        );
      }
    }
  }


  @override
  void dispose() {
    _focusNode?.dispose();
    _usernameController?.dispose();
    _firstNameController?.dispose();
    _passwordController?.dispose();
    _lastNameController?.dispose();
    super.dispose();
  }

}
