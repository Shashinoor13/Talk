import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:talk/app.dart';
import 'package:talk/firebase_options.dart';
import 'package:talk/register_dependencies.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);
  registerDependencies();
  runApp(MyApp());
}


