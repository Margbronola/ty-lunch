import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tylunch/global/datacacher.dart';
import 'package:tylunch/tylunchapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final DataCacher cacher = DataCacher.instance;
  await cacher.init();
  runApp(const TyLunchApp());
}
