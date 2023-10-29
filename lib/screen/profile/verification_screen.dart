import 'package:flutter/material.dart';
import 'package:servicehubprovider/api/api_controller.dart';
import 'package:servicehubprovider/styles.dart';
import 'package:servicehubprovider/widget/rounded_button.dart';
import '../../utils/Colors.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen(
      {super.key, required this.userId, required this.PhoneNumber});

  final String userId;
  final String PhoneNumber;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  Apicontroller apicontroller = Apicontroller();
  final otpController = TextEditingController();
  final otpFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    otpController.dispose();
    otpFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(context),
      backgroundColor: white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verification',
              style: screenTitle,
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Enter 6 digit verfication code we\'ve sent on you given number.',
              style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 20,
                  color: darkText,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 28,
            ),
            const Text(
              'Enter OTP',
              style: labelText,
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                focusNode: otpFocusNode,
                style: const TextStyle(
                    fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                decoration: formInputStyle),
            const SizedBox(
              height: 40,
            ),
            RoundedButton(
              buttonText: 'Continue',
              onPress: () {
                setState(() {
                  apicontroller.validateotp(
                      widget.userId, otpController.text, context);
                });
              },
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                apicontroller.otpgenarate(
                    widget.PhoneNumber.toString(), context);
              },
              child: const Align(
                alignment: Alignment.topRight,
                child: Text(
                  'Send Again',
                  style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 20,
                      color: kPrimary,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
