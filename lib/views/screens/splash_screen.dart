import 'dart:async';

import 'package:budget_tracker_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Get.offNamed(Routes.home);
    });
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          Image.network(
            "https://cdn-icons-png.freepik.com/256/1211/1211547.png?semt=ais_hybrid",
            height: 150,
          ),
          const Spacer(),
          const LinearProgressIndicator(
            color: Color(0xff1db794),
          )
        ],
      ),
    );
  }
}
