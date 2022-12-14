import 'dart:async';
import 'package:flutter/material.dart';
import 'package:homestayraya/models/user.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    User user = User(
        id: "0",
        name: "Unregistered",
        email: "Unregistered",
        phone: "0123456789",
        address: "NA",
        regdate: "0",
        otp: "0");
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => HomeScreen(
                      user: user,
                    ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/homestay.png'),
                    fit: BoxFit.cover))),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              SizedBox(height: 200),
              CircularProgressIndicator(
                color: Colors.white,
              ),
              SizedBox(height: 50),
              Text("Version 0.1", style: TextStyle(color: Colors.white))
            ],
          ),
        ),
      ]),
    );
  }
}
