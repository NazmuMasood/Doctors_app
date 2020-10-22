
import 'package:doctors_app/models/category.dart';
import 'package:flutter/material.dart';
String sampleText = 'Lorem ipsum dolor sit';

final DUMMY_CATEGORIES = [
  Category(
    id: 'c1',
    title: 'Doctors',
    avatar: CircleAvatar(
      radius: 40,
      backgroundImage: AssetImage('assets/images/doctor.png'),
    ),
    text: sampleText,
  ),
  Category(
    id: 'c2',
    title: 'Medicines',
    avatar: CircleAvatar(
      radius: 40,
      backgroundImage: AssetImage('assets/images/medicine.png'),
    ),
    text: sampleText,
  ),
  Category(
    id: 'c3',
    title: 'Lab Tests',
    avatar: CircleAvatar(
      radius: 40,
      backgroundImage: AssetImage('assets/images/labtest.png'),
    ),
    text: sampleText,
  ),
  Category(
    id: 'c4',
    title: 'Blood',
    avatar: CircleAvatar(
      radius: 40,
      backgroundImage: AssetImage('assets/images/blood.png'),
    ),
    text: sampleText,
  ),
  Category(
    id: 'c5',
    title: 'Tele Doctor',
    avatar: CircleAvatar(
      radius: 40,
      backgroundImage: AssetImage('assets/images/phone.png'),
    ),
    text: sampleText,
  ),
  Category(
    id: 'c6',
    title: 'Health Corner',
    avatar: CircleAvatar(
      radius: 40,
      backgroundImage: AssetImage('assets/images/health.png'),
    ),
    text: sampleText,
  ),
];