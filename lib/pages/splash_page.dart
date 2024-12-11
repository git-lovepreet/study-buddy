import 'dart:async';

import 'package:f_study_buddy/services/auth/auth_gate.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 3000),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AuthGate()));
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Image.asset("assets/logo/logo01.png",scale: 2,),
      ),
    );
  }
}
