import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicehubprovider/provider/auth_provider.dart';

import 'package:servicehubprovider/screen/login_screen.dart';

import '../widget/app_name_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Provider.of<AuthProvider>(context, listen: false).initializeUser(context);
    });

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Center(child: AppNameWidget()),
      ),
    );
  }
}
