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
    const Text("Overview Page: Page to see actual travels + Recommendation"),
    const HotelHomeScreen(),
    const Text("Chat: communication between Uploader and Searcher"),
    const Text("Profile Page: Last Travels, Likes, Settings, Support System 'Help', Button for upload Travels => page with get back button, like initial hotel_home_screen")
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
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
        // Add a fine line as a top border for the BottomNavigationBar
            Container(
              height: 1, // Thickness of the line
              color: Colors.grey.withOpacity(0.25), // Adjust color and opacity
            ),
          BottomNavigationBar(
            iconSize: 28,
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
                  icon: Icon(Icons.home_outlined), label: "Trips"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: "Explore"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.messenger_outline_rounded), label: "Messages" ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: "Profile")
            ],
          ),
        ],
      )
    );
  }
}