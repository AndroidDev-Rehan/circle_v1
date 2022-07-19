import 'package:circle/screens/chat_core/search_chat_screen.dart';
import 'package:circle/screens/view_circle_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:circle/screens/Create_Circle_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'chat_core/rooms.dart';
import 'chat_core/view_requests_page.dart';
import 'login.dart';

class MainCircle extends StatefulWidget {
  const MainCircle({Key? key}) : super(key: key);
  @override
  State<MainCircle> createState() => MainCircleState();
}

class MainCircleState extends State<MainCircle>{
  int index = 0;
  @override
  State<MainCircle> createState() => MainCircleState();

  void createACircle() {

  }

  void viewMyCircles(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder:(context) => const viewCircle()),
    );
  }

  int _currentIndex = 0;


  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        appBar: AppBar(
          elevation: 10.0,
          shadowColor: Colors.white70,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0),
            ),
            side: BorderSide(width: 0.7),

            ),
          title: const Text('Circle',
            style: TextStyle(fontSize: 25.0, fontFamily: 'Lora', letterSpacing: 1.0),
            ),
          bottom: _bottom(),
          actions:  [
            Padding(
              padding: EdgeInsets.only(
                  right: 10.0
              ),
              child: IconButton(
                  tooltip: 'Refresh',
                  icon: Icon(
                    Icons.logout_outlined,
                    size: 25.0,
                  ),
                  onPressed: () async {
                    await logout();
                  }
              ),
            ),

            InkWell(
              onTap: (){
                print("Hiragino Kaku Gothic ProN");
                Get.to(
                  SearchChatScreen()
                );
              },
              child: Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(
                  CupertinoIcons.search_circle,
                  size: 25.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 20.0
              ),
              child: IconButton(
                tooltip: 'Refresh',
                icon: Icon(
                  CupertinoIcons.refresh_circled,
                  size: 25.0,
                ),
                onPressed: () async {
                  print('Clicked Refresh in Main Window');
                }
              ),
            ),
          ],
          ),
        body:
            (_currentIndex==0) ? RoomsPage(secondVersion: true,) :
        SafeArea(
          top: false,
          bottom: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: <Widget>[
                  ElevatedButton(child:
                  const Text("View My Circles"),
                      onPressed: (){
                        Get.to(RoomsPage());
                        // viewMyCircles(context);

                  }),
                  ElevatedButton(child:
                  const Text("Create A Circle"),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CreateCirclePage()),
                        );
                      }),
                  ElevatedButton(child:
                  const Text("View Circle Invites"),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  const ViewRequestsPage()),
                        );
                      })

                ],
              ),
              // const NavigationBarItem(label: "messaging",icon: CupertinoIcons.bubble_left_bubble_right,),
              // const NavigationBarItem(label: "home",icon: Icons.home,),
              // const NavigationBarItem(label: "setting",icon: Icons.settings,)

            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue[600],

          onTap: (index)  {

             setState(() {
               this.index = index;
             });
             if(this.index == 2) {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder:(context) => RoomsPage()),
               );
             }
          },
          items:  const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(CupertinoIcons.home),
            ),
            BottomNavigationBarItem(
                label: 'Settings',
                icon: Icon(
                  Icons.group,
                ),
            ),
            BottomNavigationBarItem(
                label: 'Chat',
                icon: Icon(CupertinoIcons.chat_bubble, ),
            ),
          ],
        )
        ),
      );
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return LoginPage();
    }));
  }


  PreferredSizeWidget? _bottom() {
    return TabBar(
      indicatorPadding: EdgeInsets.only(left: 20.0, right: 20.0),
      labelColor: Colors.blueGrey,
      unselectedLabelColor: Colors.white70,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(width: 2.0, color: Colors.black87),
        insets: EdgeInsets.symmetric(horizontal: 15.0)),
      automaticIndicatorColorAdjustment: true,
      labelStyle: const TextStyle(
       fontFamily: 'Lora',
        fontWeight: FontWeight.w500,
        letterSpacing: 1.0,
      ),
      onTap: (index) {
        print("\nIndex is:$index");
        if (mounted) {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      tabs: const [
        Tab(
          child: Text(
            'Chats',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Lora',
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Tab(
          child: Text(
            'Logs',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Lora',
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Tab(
          icon: Icon(
            Icons.store,
            size: 25.0,
          ),
        ),
      ],
    );
  }
}

class NavigationBarItem extends StatelessWidget {
  const NavigationBarItem({
    Key? key, required this.label, required this.icon,}) : super(key:key);
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap:() {
        print('context');
      },
      child: SizedBox(
        height: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(
              height: 8,
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }}
