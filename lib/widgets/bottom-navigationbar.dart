import 'package:flutter/material.dart';
import 'package:mybixbite/Routes/routes.dart';
import 'package:mybixbite/User-Home-Screen/navigation-home-screen.dart';
import 'package:mybixbite/User-Home-Screen/show-map.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

class BottomNavBar extends StatefulWidget {
  final int index;

  const BottomNavBar({required this.index});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BottomNavigationBar(
        // backgroundColor: Colors.grey[100],
        selectedIconTheme: IconThemeData(
          color: Color(0xffcd6689),
        ),
        selectedItemColor: Color(0xffcd6689),
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.index,
        onTap: (value) async {},
        items: [
          BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  NavigateRoute.gotoPage(context, NavigationHomeScreen());
                  // Navigator.pushReplacement(
                  //   context,
                  //   PageRouteBuilder(
                  //     pageBuilder: (context, animation1, animation2) => FirstMainScreen(),
                  //     transitionDuration: Duration.zero,
                  //   ),
                  // );
                },
              ),
              backgroundColor: Colors.orange,
              label: "Home"),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  NavigateRoute.gotoPage(context, ShowMap());
                  // Navigator.pushReplacement(
                  //   context,
                  //   PageRouteBuilder(
                  //     pageBuilder: (context, animation1, animation2) => UserScreen(),
                  //     transitionDuration: Duration.zero,
                  //   ),
                  // );
                },
              ),
              label: "MyBixBite"),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.message),
                onPressed: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   PageRouteBuilder(
                  //     pageBuilder: (context, animation1, animation2) => ChatRoom(),
                  //     transitionDuration: Duration.zero,
                  //   ),
                  // );
                },
              ),
              label: "Chat"),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {},
              ),
              label: "Favorite"),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {},
              ),
              label: "Settings"),
        ],
      ),
    );
  }
}
