// import 'package:circle/screens/view_circle_page.dart';
// import 'package:flutter/material.dart';
// import 'package:circle/screens/Create_Circle_screen.dart';
//
// class mainCircle extends StatelessWidget {
//
//   @override
//   const mainCircle({Key? key}): super(key:key);
//
//   void createACircle() {
//
//   }
//
//   void viewMyCircles(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder:(context) => const viewCircle()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//      return Scaffold(
//        appBar: AppBar(
//          title: const Text('Circle'),
//        ),
//        body: Center(
//            child: [
//              Column(
//                children: <Widget>[
//                  MaterialButton(child:
//                  const Text("View My Circles"),
//                      onPressed: (){viewMyCircles(context);}),
//                  MaterialButton(child:
//                  const Text("Create A Circle"),
//                      onPressed: (){
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(builder: (context) => const CreateCirclePage()),
//                        );
//                      })
//                ],
//              ),
//              const NavigationBarItem(label: "messaging",icon: Icons.message,),
//              const NavigationBarItem(),
//              const NavigationBarItem()
//              const NavigationBarItem()
//
//            ],
//          ),
//        ),
//      );
//   }
// }
//
