import 'package:flutter/foundation.dart';

enum Specialities {
  GeneralMedicine,
  WomenHealth,
  Heart,
  SkinHair,
  KidneyUrinary,
  BoneJoints,
  ChildSpecialist,
  Ayurveda,
  GeneralSurgery,
  SexSpecialist,
  EyeSpecialist,
  Dental,
  Gastroenterology,
}

class Doctor{
  final String id;
  final String degrees;
  final String name;
  final String imageUrl;
  final String address;
  final List<Specialities> specialities;
  final String category;
  Doctor({@required this.name,@required this.id,@required this.category,@required this.specialities,@required this.address,@required this.degrees,@required this.imageUrl,});
}