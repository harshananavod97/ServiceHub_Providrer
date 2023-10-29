import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicehubprovider/utils/Colors.dart';
import 'package:servicehubprovider/api/api_controller.dart';
import 'package:servicehubprovider/provider/auth_provider.dart';
import 'package:servicehubprovider/widget/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

// ignore: camel_case_types
class fbgooglePhoneNumberValidation extends StatefulWidget {
  const fbgooglePhoneNumberValidation({super.key});

  @override
  State<fbgooglePhoneNumberValidation> createState() =>
      _fbgooglePhoneNumberValidationState();
}

// ignore: camel_case_types
class _fbgooglePhoneNumberValidationState
    extends State<fbgooglePhoneNumberValidation> {
  
  final _phonenoformKey = GlobalKey<FormState>();
  final _nicformKey = GlobalKey<FormState>();
  final _address1formKey = GlobalKey<FormState>();
  final _address2formKey = GlobalKey<FormState>();
  final _servicecategoryidformKey = GlobalKey<FormState>();
  final _cityformKey = GlobalKey<FormState>();
  final _descriptionformKey = GlobalKey<FormState>();


  Apicontroller apicontroller = Apicontroller();
  final fullNameControlleer = TextEditingController();
  final phoneNumberControlleer = TextEditingController();
  final niccontroller = TextEditingController();
  final emailControlleer = TextEditingController();
  final cityControlleer = TextEditingController();
  final address1Controlleer = TextEditingController();
  final address2Controlleer = TextEditingController();
  final serivicecatergoryIdcontroller = TextEditingController();
  final descriptionControlleer = TextEditingController();

  AutovalidateMode switched = AutovalidateMode.disabled;

  final fullNameFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final nicFocusNode = FocusNode();

  final cityFocusNode = FocusNode();
  final address1 = FocusNode();
  final address2 = FocusNode();
  final servicecatrgogrId = FocusNode();
  final descriptionfocusnode = FocusNode();

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
    serivicecatergoryIdcontroller.dispose();
    descriptionControlleer.dispose();
    descriptionfocusnode.dispose();
    address1.dispose();
    address2.dispose();
    cityFocusNode.dispose();
    servicecatrgogrId.dispose();
  }

  String customerid = '';

  getUserData() async {
    final ids = await SharedPreferences.getInstance();
    customerid = ids.getString("id").toString();
    print("my id is" + customerid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
      child: Consumer<AuthProvider>(
        builder: (context, value, child) => SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Create Account',
                  style: screenTitle,
                ),
                const SizedBox(
                  height: 22,
                ),
                const Text(
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
                      final nicRegex = RegExp(r'^\d{9}[vVxX]?$');
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
                inputField('Address1', emailControlleer,
                    TextInputType.emailAddress, emailFocusNode),
                const SizedBox(
                  height: 8,
                ),
                Form(
                  key: _address1formKey,
                  autovalidateMode: switched,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Address1 is required';
                      }

                      if (value.length > 255) {
                        return 'Address1 name cannot exceed 255 characters';
                      }
                      return null;
                    },
                    controller: address1Controlleer,
                    keyboardType: TextInputType.text,
                    focusNode: address1,
                    style: const TextStyle(
                        fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                    decoration: formInputStyle,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                inputField('Address2', emailControlleer,
                    TextInputType.emailAddress, emailFocusNode),
                const SizedBox(
                  height: 8,
                ),
                Form(
                  key: _address2formKey,
                  autovalidateMode: switched,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Address2 is required';
                      }

                      if (value.length > 255) {
                        return 'Address2 name cannot exceed 255 characters';
                      }
                      return null;
                    },
                    controller: address2Controlleer,
                    keyboardType: TextInputType.text,
                    focusNode: address2,
                    style: const TextStyle(
                        fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                    decoration: formInputStyle,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                inputField('City', emailControlleer, TextInputType.emailAddress,
                    emailFocusNode),
                const SizedBox(
                  height: 8,
                ),
                Form(
                  key: _cityformKey,
                  autovalidateMode: switched,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'City is required';
                      }

                      if (value.length > 255) {
                        return 'City name cannot exceed 255 characters';
                      }
                      return null;
                    },
                    controller: cityControlleer,
                    keyboardType: TextInputType.text,
                    focusNode: cityFocusNode,
                    style: const TextStyle(
                        fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                    decoration: formInputStyle,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                inputField('Service Catergory Id', emailControlleer,
                    TextInputType.emailAddress, emailFocusNode),
                const SizedBox(
                  height: 8,
                ),
                Form(
                  key: _servicecategoryidformKey,
                  autovalidateMode: switched,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Service Catergory Id is required';
                      }

                      if (value.length > 255) {
                        return 'Service Catergory Id cannot exceed 255 characters';
                      }
                      return null;
                    },
                    controller: serivicecatergoryIdcontroller,
                    keyboardType: TextInputType.number,
                    focusNode: servicecatrgogrId,
                    style: const TextStyle(
                        fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                    decoration: formInputStyle,
                  ),
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
                    focusNode: descriptionfocusnode,
                    style: const TextStyle(
                        fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                    decoration: formInputStyle,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RoundedButton(
                  //login button............................
                  buttonText: 'Login',
                  onPress: () async {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => MainScreen(),
                    //     ));

                    setState(() {
                      switched = AutovalidateMode.always;
                    });
                    if (_phonenoformKey.currentState!.validate() &&
                        _address1formKey.currentState!.validate() &&
                        _address2formKey.currentState!.validate() &&
                        _cityformKey.currentState!.validate() &&
                        _phonenoformKey.currentState!.validate() &&
                        _nicformKey.currentState!.validate() &&
                        _descriptionformKey.currentState!.validate() &&
                        _servicecategoryidformKey.currentState!.validate()) {
                          //facebook
                      await value.favalable
                          ? apicontroller.fbgoogleregister(
                              value.femail.text,
                              value.fusername.text,
                              phoneNumberControlleer.text,
                              cityControlleer.text,
                              serivicecatergoryIdcontroller.text,
                              descriptionControlleer.text,
                              address1Controlleer.text,
                              address2Controlleer.text,
                              niccontroller.text,
                              'mmmmmmm',
                              context)
                              //google
                          : await value.gavalable
                              ? apicontroller.fbgoogleregister(
                                  value.gemail.text,
                                  value.gusername.text,
                                  phoneNumberControlleer.text,
                                  cityControlleer.text,
                                  serivicecatergoryIdcontroller.text,
                                  descriptionControlleer.text,
                                  address1Controlleer.text,
                                  address2Controlleer.text,
                                  niccontroller.text,
                                  'mmmmmmm',
                                  context)
                              : showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Your Registration Failed '),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginScreen(),
                                                ));
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ]),
        ),
      ),
    ));
  }

  //phone number validation function
  bool isValidPhoneNumber(String phoneNumber) {
    final RegExp regex = RegExp(r"^\d{10}$");
    return regex.hasMatch(phoneNumber);
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
