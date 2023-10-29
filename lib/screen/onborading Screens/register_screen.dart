import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicehubprovider/utils/Colors.dart';
import 'package:servicehubprovider/Notifications/getfcm.dart';
import 'package:servicehubprovider/api/api_controller.dart';
import 'package:servicehubprovider/styles.dart';
import 'package:servicehubprovider/utils/constant.dart';
import 'package:servicehubprovider/widget/rounded_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List data = [];
  int _value = 1;
  getdata() async {
    final res = await http
        .get(Uri.parse(constant.APPEND_URL + 'service-category-name'));
    data = jsonDecode(res.body);

    setState(() {});
  }

  final _emailformKey = GlobalKey<FormState>();
  final _fullnameformKey = GlobalKey<FormState>();
  final _phonenoformKey = GlobalKey<FormState>();
  final _nicformKey = GlobalKey<FormState>();
  final _descriptionformKey = GlobalKey<FormState>();

  Apicontroller apicontroller = Apicontroller();
  final fullNameControlleer = TextEditingController();
  final phoneNumberControlleer = TextEditingController();
  final niccontroller = TextEditingController();
  final emailControlleer = TextEditingController();
  final cityControlleer = TextEditingController();
  final address1Controlleer = TextEditingController();
  final address2Controlleer = TextEditingController();
  final descriptionControlleer = TextEditingController();

  AutovalidateMode switched = AutovalidateMode.disabled;

  final fullNameFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final nicFocusNode = FocusNode();

  final cityFocusNode = FocusNode();

  final DescriptionFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    fullNameFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    emailFocusNode.dispose();
    fullNameControlleer.dispose();
    phoneNumberControlleer.dispose();
    emailControlleer.dispose();
    niccontroller.dispose();
    nicFocusNode.dispose();
    address1Controlleer.dispose();
    address2Controlleer.dispose();
    cityControlleer.dispose();
    descriptionControlleer.dispose();
    DescriptionFocusNode.dispose();

    cityFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getdata();
    return Scaffold(
      appBar: Styles.appBar(context),
      backgroundColor: white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Account',
                  style: screenTitle,
                ),
                const SizedBox(
                  height: 22,
                ),
                inputField('Full Name', fullNameControlleer, TextInputType.text,
                    fullNameFocusNode),
                Form(
                  key: _fullnameformKey,
                  autovalidateMode: switched,
                  child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Full name is required';
                        }
                        if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                          return 'Full name can only contain letters and spaces';
                        }
                        if (value.length > 255) {
                          return 'Full name cannot exceed 255 characters';
                        }
                        return null;
                      },
                      controller: fullNameControlleer,
                      keyboardType: TextInputType.text,
                      focusNode: fullNameFocusNode,
                      style: const TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 20,
                          color: lightText),
                      decoration: formInputStyle),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Phone Number",
                  style: labelText,
                ),
                const SizedBox(
                  height: 8,
                ),
                Form(
                  autovalidateMode: switched,
                  key: _phonenoformKey,
                  child: TextFormField(
                    maxLength: 10,
                    controller: phoneNumberControlleer,
                    keyboardType: TextInputType.number,
                    focusNode: phoneNumberFocusNode,
                    style: const TextStyle(
                        fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                    decoration: formInputStyle,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      if (value.length != 10) {
                        return 'Phone number must have 10 digits';
                      }
                      if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                        return 'Invalid phone number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                inputField('Email', emailControlleer,
                    TextInputType.emailAddress, emailFocusNode),
                Form(
                  key: _emailformKey,
                  autovalidateMode: switched,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Invalid email address';
                      }
                      if (value.length > 255) {
                        return 'Email name cannot exceed 255 characters';
                      }
                      return null;
                    },
                    controller: emailControlleer,
                    keyboardType: TextInputType.text,
                    focusNode: emailFocusNode,
                    style: const TextStyle(
                        fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                    decoration: formInputStyle,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                inputField('Nic', emailControlleer, TextInputType.emailAddress,
                    emailFocusNode),
                const SizedBox(
                  height: 8,
                ),
                Form(
                  key: _nicformKey,
                  autovalidateMode: switched,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'NIC number is required';
                      }
                      final nicRegex = RegExp(r'^\d{9}[vVxX]?$|^(\d{12})$');
                      if (!nicRegex.hasMatch(value)) {
                        return 'Invalid NIC number';
                      }
                      if (value.length > 255) {
                        return 'Nic number cannot exceed 255 characters';
                      }
                      return null;
                    },
                    controller: niccontroller,
                    keyboardType: TextInputType.text,
                    focusNode: nicFocusNode,
                    style: const TextStyle(
                        fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                    decoration: formInputStyle,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // inputField('Address1', emailControlleer,
                //     TextInputType.emailAddress, emailFocusNode),
                // const SizedBox(
                //   height: 8,
                // ),
                // Form(
                //   key: _address1formKey,
                //   autovalidateMode: switched,
                //   child: TextFormField(
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Address1 is required';
                //       }

                //       if (value.length > 255) {
                //         return 'Address1 name cannot exceed 255 characters';
                //       }
                //       return null;
                //     },
                //     controller: address1Controlleer,
                //     keyboardType: TextInputType.text,
                //     focusNode: Address1FocusNode,
                //     style: const TextStyle(
                //         fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                //     decoration: formInputStyle,
                //   ),
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                // inputField('Address2', emailControlleer,
                //     TextInputType.emailAddress, emailFocusNode),
                // const SizedBox(
                //   height: 8,
                // ),
                // Form(
                //   key: _address2formKey,
                //   autovalidateMode: switched,
                //   child: TextFormField(
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Address2 is required';
                //       }

                //       if (value.length > 255) {
                //         return 'Address2 name cannot exceed 255 characters';
                //       }
                //       return null;
                //     },
                //     controller: address2Controlleer,
                //     keyboardType: TextInputType.text,
                //     focusNode: Address2FocusNode,
                //     style: const TextStyle(
                //         fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                //     decoration: formInputStyle,
                //   ),
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                // inputField('City', emailControlleer, TextInputType.emailAddress,
                //     emailFocusNode),
                // const SizedBox(
                //   height: 8,
                // ),
                // Form(
                //   key: _cityformKey,
                //   autovalidateMode: switched,
                //   child: TextFormField(
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'City is required';
                //       }

                //       if (value.length > 255) {
                //         return 'City name cannot exceed 255 characters';
                //       }
                //       return null;
                //     },
                //     controller: cityControlleer,
                //     keyboardType: TextInputType.text,
                //     focusNode: cityFocusNode,
                //     style: const TextStyle(
                //         fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                //     decoration: formInputStyle,
                //   ),
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                inputField('Service Catergory Id', emailControlleer,
                    TextInputType.emailAddress, emailFocusNode),

                //     TextInputType.emailAddress, emailFocusNode),
                Container(
                  color: inputFieldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: DropdownButton(
                      items: data.map((e) {
                        return DropdownMenuItem(
                          child: Text(
                              e["name"].length > 23
                                  ? e["name"].substring(0, 23) + ".."
                                  : e["name"],
                              style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 20,
                                  color: lightText)),
                          value: e["id"],
                        );
                      }).toList(),
                      value: _value,
                      onChanged: (v) {
                        setState(() {
                          _value = v as int;
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),

                const SizedBox(
                  height: 20,
                ),
                inputField('Description', emailControlleer,
                    TextInputType.emailAddress, emailFocusNode),
                const SizedBox(
                  height: 8,
                ),
                Form(
                  key: _descriptionformKey,
                  autovalidateMode: switched,
                  child: TextFormField(
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description is required';
                      }

                      if (value.length > 255) {
                        return 'Description cannot exceed 255 characters';
                      }
                      return null;
                    },
                    controller: descriptionControlleer,
                    keyboardType: TextInputType.text,
                    focusNode: DescriptionFocusNode,
                    style: const TextStyle(
                        fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                    decoration: formInputStyle,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                RoundedButton(
                  buttonText: 'Signup Now',
                  onPress: () async {
                    String? fcmKey = await getFcmToken();
                    setState(() {
                      switched = AutovalidateMode.always;
                    });
                    if (_phonenoformKey.currentState!.validate() &&
                        _fullnameformKey.currentState!.validate() &&
                        _emailformKey.currentState!.validate() &&
                        _phonenoformKey.currentState!.validate() &&
                        _nicformKey.currentState!.validate() &&
                        _descriptionformKey.currentState!.validate()) {
                      apicontroller.register(
                          emailControlleer.text,
                          fullNameControlleer.text,
                          phoneNumberControlleer.text,
                          "",
                          _value.toString(),
                          descriptionControlleer.text,
                          "",
                          "",
                          niccontroller.text,
                          '123456',
                          fcmKey.toString(),
                          context);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 26,
            ),
            const Text(
              'By Sign up you\' re agree to our Terms & Conditions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 15.0,
                color: darkText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputField(
    String labelName,
    TextEditingController controller,
    TextInputType inputType,
    FocusNode focusNode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelName,
          style: labelText,
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
