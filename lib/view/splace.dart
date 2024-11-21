import 'dart:async';
import 'package:flutter/material.dart';
import 'package:media_player/view/homepage.dart';
// For navigation if you're using GetX.

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to the home page after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MXHomePage(),)); // Replace '/home' with your route
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for a video player theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo or Video Icon
            Icon(
              Icons.play_circle_fill,
              color: Colors.redAccent,
              size: 100,
            ),
            SizedBox(height: 20),
            // App Name
            Text(
              "Video Player",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            // Loading Animation
            CircularProgressIndicator(
              color: Colors.redAccent,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}


