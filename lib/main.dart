import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'splash/splashscreen.dart';
// @dart=2.9

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
     // home:  ScreenEsasSehfe(),
      home:  AnimationScreen(color: Colors.green,),
    );
  }
}
