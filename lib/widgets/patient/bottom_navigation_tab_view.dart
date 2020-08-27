import 'package:doctors_app/widgets/patient/profile.dart';
import 'package:doctors_app/widgets/patient/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:doctors_app/screens/patient/home.dart';
import 'appointment_history.dart';


class BottomNavigationTabView extends StatefulWidget {
  final user;
  BottomNavigationTabView(this.user);
  @override
  _BottomNavigationTabViewState createState() => _BottomNavigationTabViewState();
}

class _BottomNavigationTabViewState extends State<BottomNavigationTabView> {
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);


  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        activeColor: Colors.teal,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.calendar),
        activeColor: Colors.teal,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_circle),
        activeColor: Colors.teal,
        inactiveColor: CupertinoColors.systemGrey,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(user: widget.user),
      AppointmentHistory(),
      UserofProfile(),
     // Scaffold(body: Center(child: Text('Profile here'),),),
    ];
  }// this is your user instance
    @override
  Widget build(BuildContext context) {
    return PersistentTabView(
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears.
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style6,
      );
  }
}
