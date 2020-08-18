import 'package:doctors_app/responsive/device_screen_type.dart';
import 'package:flutter/material.dart';
DeviceScreenType getDeviceType(MediaQueryData mediaQuery){
double deviceWidth = mediaQuery.size.shortestSide;

if(deviceWidth > 600)
  {
    return DeviceScreenType.Tablet;
  }
return DeviceScreenType.Mobile;
}