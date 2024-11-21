import 'package:flutter/material.dart';
import 'package:media_player/privider/provider.dart';
import 'package:media_player/view/homepage.dart';
import 'package:media_player/view/splace.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VideoProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {

          '/' : (context)=> SplashScreen(),
        },
      ),
    );
  }
}