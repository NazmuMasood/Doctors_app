import 'package:doctors_app/screens/patient/appointment_list/appointment_list_screen.dart';
import 'package:doctors_app/screens/patient/user_profile/user_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:doctors_app/screens/patient/home/home_screen.dart';


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
        icon: Icon(Icons.home,size: 31),
        activeColor: Colors.teal,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.calendar,size: 29),
        activeColor: Colors.teal,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_circle,size: 29),
        activeColor: Colors.teal,
        inactiveColor: CupertinoColors.systemGrey,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(user: widget.user),
      AppointmentListScreen(user: widget.user),
      UserProfileScreen(user: widget.user),
    ];
  }// this is your user instance
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      navBarHeight: 60,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white60,
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
