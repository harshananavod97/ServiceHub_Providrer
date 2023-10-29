import 'package:flutter/material.dart';
import 'package:servicehubprovider/utils/Colors.dart';
import 'package:servicehubprovider/screen/appoinments/allnewAppoinments.dart';
import 'package:servicehubprovider/widget/rounded_border_button.dart';
import 'package:servicehubprovider/widget/rounded_button.dart';
import '../Main Screens/Drawer.dart';

class AppoinmentCompleteScreen extends StatelessWidget {
  const AppoinmentCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
          color: white,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/check.png',
                      width: 250,
                      height: 250,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Request\nSubmitted',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 30.0,
                        color: darkText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Your appointment has been\nprocessed with servicehub',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 12.0,
                        color: lightGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    RoundedButton(
                      buttonText: 'View Appoinmnets',
                      onPress: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const AllnewAppoinments()),
                            (route) => true);
                      },
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    RoundedBorderButton(
                      buttonText: 'Home',
                      buttonBackground: white,
                      textColor: kPrimary,
                      onPress: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()),
                            (route) => false);
                      },
                    ),
                  ],
                )
              ]),
        ),
      ),
    ));
  }
}
