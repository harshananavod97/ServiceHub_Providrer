import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:servicehubprovider/Colors.dart';
import 'package:servicehubprovider/api/api_controller.dart';
import 'package:servicehubprovider/screen/Add_address.dart';
import 'package:servicehubprovider/screen/verification_screen.dart';
import 'package:servicehubprovider/utils/Custom_Text.dart';
import 'package:servicehubprovider/utils/constant.dart';
import 'package:servicehubprovider/utils/image_picker.dart';
import 'package:servicehubprovider/widget/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/image_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String address1 = '', address2 = '', city = '', latitude = '', logitude = '';

  List data = [];
  int _value = 1;
  getdata() async {
    final res = await http
        .get(Uri.parse(constant.APPEND_URL + 'service-category-name'));
    data = jsonDecode(res.body);

    setState(() {});
  }

  Apicontroller apicontroller = Apicontroller();
  bool _isButtonOn = true;
  bool _readonly = true;
  String providerid = "";
  String profilepic = "";
  getUserData() async {
    final ids = await SharedPreferences.getInstance();
    final idss = await SharedPreferences.getInstance();

    print("getcustomerdata called " + ids.getString('full_name').toString());

    ids.getString("id").toString().isNotEmpty
        ? providerid = ids.getString("id").toString()
        : providerid = idss.getString("id").toString();

    print("my id is" + providerid);
    apicontroller.getproviderdetails(providerid);
  }

  getproviderrdata() async {
    final providerdetails = await SharedPreferences.getInstance();

    setState(() {
      print(providerdetails.getString('full_name').toString());
      providerdetails != null && providerdetails.getString('full_name') != null
          ? fullNameControlleer.text =
              providerdetails.getString('full_name').toString()
          : fullNameControlleer.text = "Full name";

      providerdetails != null && providerdetails.getString('email') != null
          ? emailControlleer.text =
              providerdetails.getString('email').toString()
          : emailControlleer.text =
              providerdetails.getString('email').toString();

      phoneNumberControlleer.text =
          providerdetails.getString('phone_number').toString();

      cityControlleer.text = providerdetails.getString('city').toString();
      address1Controlleer.text =
          providerdetails.getString('address1').toString();
      address2Controlleer.text =
          providerdetails.getString('address2').toString();
      descriptionControlleer.text =
          providerdetails.getString('description').toString();
      ServicecatergoryIdControlleer.text =
          providerdetails.getString('servicecatergoryid').toString();
      NicControlleer.text = providerdetails.getString('nic').toString();
      profilepic = providerdetails.getString('profile_pic').toString();
      ingControlleer.text = providerdetails.getString('ing').toString();
      latControlleer.text = providerdetails.getString('lat').toString();
    });
  }

  void _toggleButton() {
    setState(() {
      _isButtonOn = !_isButtonOn;
    });
  }

//customer detais readonly method
  void readonly() {
    setState(() {
      _readonly = !_readonly;
    });
  }

  File? _image;
  PickedFile? _pickedFile;
  final _picker = ImagePicker();
  // Implementing the image picker
  Future<void> _pickImage() async {
    _pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (_pickedFile != null) {
      setState(() {
        _image = File(_pickedFile!.path);
      });
    }
  }

  final CarouselController _controller = CarouselController();
  int _current = 0;

  final _emailformKey = GlobalKey<FormState>();
  final _fullnameformKey = GlobalKey<FormState>();
  final _phonenoformKey = GlobalKey<FormState>();
  final _nicformKey = GlobalKey<FormState>();
  final _address1formKey = GlobalKey<FormState>();
  final _address2formKey = GlobalKey<FormState>();
  final _servicecategoryidformKey = GlobalKey<FormState>();
  final _cityformKey = GlobalKey<FormState>();
  final _descriptionformKey = GlobalKey<FormState>();

  final fullNameControlleer = TextEditingController();
  final phoneNumberControlleer = TextEditingController();
  final NicControlleer = TextEditingController();
  final emailControlleer = TextEditingController();
  final cityControlleer = TextEditingController();
  final address1Controlleer = TextEditingController();
  final address2Controlleer = TextEditingController();
  final ServicecatergoryIdControlleer = TextEditingController();
  final descriptionControlleer = TextEditingController();
  final latControlleer = TextEditingController();
  final ingControlleer = TextEditingController();
  AutovalidateMode switched = AutovalidateMode.disabled;

  final fullNameFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final NicFocusNode = FocusNode();

  final cityFocusNode = FocusNode();
  final Address1FocusNode = FocusNode();
  final Address2FocusNode = FocusNode();
  final ServiceCatergoryIdFocusNode = FocusNode();
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
    NicControlleer.dispose();
    NicFocusNode.dispose();
    address1Controlleer.dispose();
    address2Controlleer.dispose();
    cityControlleer.dispose();
    ServicecatergoryIdControlleer.dispose();
    descriptionControlleer.dispose();
    DescriptionFocusNode.dispose();
    Address1FocusNode.dispose();
    Address2FocusNode.dispose();
    cityFocusNode.dispose();
    ServiceCatergoryIdFocusNode.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserData();

    getproviderrdata();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(
      () => ImageController(),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: GetBuilder<ImageController>(builder: (imageController) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'My Profile',
                      style: screenTitle,
                    ),
                    const SizedBox(height: 35),
                    Center(
                      child: ClipOval(
                        child: Container(
                          alignment: Alignment.center,
                          width: 200,
                          height: 200,
                          color: Colors.grey[300],
                          child: profilepic != null
                              ? Image.network(
                                  'https://servicehub.clickytesting.xyz/' +
                                      profilepic,
                                  fit: BoxFit.cover,
                                )
                              : const Text('Please select an image'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 20, left: 60, right: 60),
                      child: RoundedButton(
                          buttonText: "Upload Photo",
                          onPress: () async {
                            await imageController.pickImage(
                                providerid, context);
                            await apicontroller.getcustomerdetails(providerid);
                          }),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    inputField('Full Name', fullNameControlleer,
                        TextInputType.text, fullNameFocusNode),
                    const SizedBox(
                      height: 8,
                    ),
                    Form(
                      key: _fullnameformKey,
                      autovalidateMode: switched,
                      child: TextFormField(
                          readOnly: _readonly,
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
                        readOnly: _readonly,
                        maxLength: 10,
                        controller: phoneNumberControlleer,
                        keyboardType: TextInputType.number,
                        focusNode: phoneNumberFocusNode,
                        style: const TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 20,
                            color: lightText),
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
                    const SizedBox(
                      height: 8,
                    ),
                    Form(
                      key: _emailformKey,
                      autovalidateMode: switched,
                      child: TextFormField(
                        readOnly: _readonly,
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
                            fontFamily: 'Segoe UI',
                            fontSize: 20,
                            color: lightText),
                        decoration: formInputStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    inputField('Nic', emailControlleer,
                        TextInputType.emailAddress, emailFocusNode),
                    const SizedBox(
                      height: 8,
                    ),
                    Form(
                      key: _nicformKey,
                      autovalidateMode: switched,
                      child: TextFormField(
                        readOnly: _readonly,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'NIC number is required';
                          }
                          final nicRegex = RegExp(r'^\d{9}[vVxX]$');
                          final nicRegexWith12Digits = RegExp(r'^\d{12}$');
                          if (!nicRegex.hasMatch(value) &&
                              !nicRegexWith12Digits.hasMatch(value)) {
                            return 'Invalid NIC number';
                          }
                          if (value.length > 255) {
                            return 'Nic number cannot exceed 255 characters';
                          }

                          return null;
                        },
                        controller: NicControlleer,
                        keyboardType: TextInputType.text,
                        focusNode: NicFocusNode,
                        style: const TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 20,
                            color: lightText),
                        decoration: formInputStyle,
                      ),
                    ),
                    //location adding field need to add
                    const SizedBox(
                      height: 20,
                    ),

                    inputField('Add Your Address', emailControlleer,
                        TextInputType.emailAddress, emailFocusNode),
                    const SizedBox(
                      height: 8,
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => AddNewAdrressScreen(
                                      desc: descriptionControlleer.text,
                                      email: emailControlleer.text,
                                      fullname: fullNameControlleer.text,
                                      nic: NicControlleer.text,
                                      providerid: providerid,
                                      serviceid:
                                          ServicecatergoryIdControlleer.text,
                                      phonenumber: phoneNumberControlleer.text,
                                    )),
                            (route) => false);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: const BoxDecoration(
                            color: inputFieldBackgroundColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 80,
                              ),
                              CustomText(
                                  text: address1Controlleer.text,
                                  color: lightText,
                                  fontfamily: 'Segoe UI',
                                  fontweight: FontWeight.normal,
                                  size: 20),
                              CustomText(
                                  text: address2Controlleer.text,
                                  color: lightText,
                                  fontfamily: 'Segoe UI',
                                  fontweight: FontWeight.normal,
                                  size: 20),
                              CustomText(
                                  text: cityControlleer.text,
                                  color: lightText,
                                  fontfamily: 'Segoe UI',
                                  fontweight: FontWeight.normal,
                                  size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
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
                        readOnly: _readonly,
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
                            fontFamily: 'Segoe UI',
                            fontSize: 20,
                            color: lightText),
                        decoration: formInputStyle,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _isButtonOn
                        ? RoundedButton(
                            buttonText: 'Edit Profile',
                            onPress: () {
                              print("edit button");
                              readonly();
                              _toggleButton();
                            },
                          )
                        : RoundedButton(
                            buttonText: 'Save',
                            onPress: () async {
                              final providerdetails =
                                  await SharedPreferences.getInstance();

                              switched = AutovalidateMode.always;

                              if (_phonenoformKey.currentState!.validate() &&
                                  _fullnameformKey.currentState!.validate() &&
                                  _emailformKey.currentState!.validate() &&
                                  _phonenoformKey.currentState!.validate() &&
                                  _nicformKey.currentState!.validate() &&
                                  _descriptionformKey.currentState!
                                      .validate()) {
                                if (providerdetails
                                        .getString('phone_number')
                                        .toString() ==
                                    phoneNumberControlleer.text) {
                                  apicontroller.updateProviderDetails(
                                      providerid.toString(),
                                      fullNameControlleer.text,
                                      emailControlleer.text,
                                      phoneNumberControlleer.text,
                                      NicControlleer.text,
                                      address1Controlleer.text,
                                      address2Controlleer.text,
                                      cityControlleer.text,
                                      ServicecatergoryIdControlleer.text,
                                      descriptionControlleer.text,
                                      '123456',
                                      latControlleer.text,
                                      ingControlleer.text,
                                      context);
                                } else {
                                  apicontroller.updateProviderDetails(
                                      providerid.toString(),
                                      fullNameControlleer.text,
                                      emailControlleer.text,
                                      phoneNumberControlleer.text,
                                      NicControlleer.text,
                                      address1Controlleer.text,
                                      address2Controlleer.text,
                                      cityControlleer.text,
                                      ServicecatergoryIdControlleer.text,
                                      descriptionControlleer.text,
                                      latControlleer.text,
                                      ingControlleer.text,
                                      '123456',
                                      context);

                                  await apicontroller.otpgenarate(
                                      phoneNumberControlleer.text, context);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            VerificationScreen(
                                                userId: providerid.toString(),
                                                PhoneNumber:
                                                    phoneNumberControlleer
                                                        .text),
                                      ));
                                }

                                readonly();
                                _toggleButton();
                              }
                            }),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget inputField(String labelName, TextEditingController controller,
      TextInputType inputType, FocusNode focusNode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelName,
          style: labelText,
        ),
      ],
    );
  }
}
