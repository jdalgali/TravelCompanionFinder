import 'package:flutter/material.dart';
import 'hotel_booking/hotel_home_screen.dart';
import 'app_theme.dart';


class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex = 1;
  static final List<Widget> _widgetOptions = <Widget>[
    const Text("Page01, TODO"),
    const HotelHomeScreen(),
    const Text("Page02, TODO")
  ];

  void onPageTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    //print("Tapped index is: " + selectedIndex.toString());
  }

  @override
  Widget build(BuildContext context) {
    return
        //SafeArea(
        //child:
        Scaffold(
      //appBar: null,
      //  backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      // ),
      // extendBodyBehindAppBar: true,
      body: Center(
        child: _widgetOptions[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onPageTap,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: AppTheme.selectedItemColor,
        unselectedItemColor: AppTheme.unselectedItemColor,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Page01"),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: "Page02"),
          BottomNavigationBarItem(
              icon: Icon(Icons.sunny),
              activeIcon:
                  Icon(Icons.cloud),
              label: "Page03")
        ],
      ),
      //)
    );
  }
}