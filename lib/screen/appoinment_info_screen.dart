import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:servicehubprovider/Colors.dart';
import 'package:servicehubprovider/api/api_controller.dart';
import 'package:servicehubprovider/model/PendingAppoiments.dart';
import 'package:servicehubprovider/model/QuiedAppoiment.dart';
import 'package:servicehubprovider/screen/Add_address.dart';
import 'package:servicehubprovider/screen/appoinment_first_task_screen.dart';
import 'package:servicehubprovider/screen/main_screen.dart';
import 'package:servicehubprovider/utils/Navigation_Function.dart';
import 'package:servicehubprovider/utils/constant.dart';
import 'package:servicehubprovider/widget/rounded_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AppoinmentInfoScreen extends StatefulWidget {
  AppoinmentInfoScreen({super.key, required this.index});
  int index;

  @override
  State<AppoinmentInfoScreen> createState() => _AppoinmentInfoScreenState();
}

class _AppoinmentInfoScreenState extends State<AppoinmentInfoScreen> {
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
  String checker = "";
  String profilepic = "";

  getproviderrdata() async {
    final providerdetails = await SharedPreferences.getInstance();

    setState(() {
      checker = providerdetails.getString('address1').toString();
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

      descriptionControlleer.text =
          providerdetails.getString('description').toString();
      ServicecatergoryIdControlleer.text =
          providerdetails.getString('servicecatergoryid').toString();
      NicControlleer.text = providerdetails.getString('nic').toString();
      profilepic = providerdetails.getString('profile_pic').toString();
    });
  }

  Apicontroller apicontroller = Apicontroller();

  String providerid = "";
  String service_category_id = "";
  getUserData() async {
    final ids = await SharedPreferences.getInstance();
    final idss = await SharedPreferences.getInstance();

    print("getcustomerdata called " + ids.getString('full_name').toString());
    setState(() {
      ids.getString("id").toString().isNotEmpty
          ? providerid = ids.getString("id").toString()
          : providerid = idss.getString("id").toString();
      apicontroller.getproviderdetails(providerid);

      service_category_id = idss.getString("servicecatergoryid").toString();
    });

    print("my id is " + providerid);
    print("my service is " + service_category_id);
  }

  @override
  void initState() {
    // TODO: implement initState
    getproviderrdata();
    getUserData();
    super.initState();
  }

  List<QueiedApoinmentList> apoinmentlist = [];
  Future<List<QueiedApoinmentList>> getQueiedApoiment(String id) async {
    apoinmentlist.clear();
    var url = Uri.parse(
        // ignore: prefer_interpolation_to_compose_strings
        constant.APPEND_URL + "queued-appointments?id=$id");
    final response = await http.get(url);
    print(response.body);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      print('load sucess');

      final appontment = queiedApoinmentListFromJson(response.body);

      print("appointment " + appontment.length.toString());

      apoinmentlist.addAll(appontment);
      print(response.body);

      return apoinmentlist;
    } else {
      return apoinmentlist;

      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        //leadingWidth: 30,
        titleSpacing: 0,
        backgroundColor: white,
        foregroundColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.only(left: 22),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 24,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text('Back'),
        actions: const [
          // Padding(
          //   padding: EdgeInsets.only(top: 10, right: 25),
          //   child: Text(
          //     'Cancel',
          //     style: TextStyle(
          //       fontFamily: 'Segoe UI',
          //       fontSize: 22.0,
          //       color: Color(0xFFEA4600),
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
        child: FutureBuilder(
          future: getQueiedApoiment(service_category_id.toString()),
          builder: (context,
                  AsyncSnapshot<List<QueiedApoinmentList>> snapshot) =>
              apoinmentlist.isEmpty
                  ? Center(child: const CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          const Text(
                            'Appointment Info',
                            style: screenTitle,
                          ),

                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            'Confirmed on ' +
                                DateFormat('yyyy-MM-dd HH:mm').format(snapshot
                                    .data![widget.index]
                                    .serviceCategory
                                    .createdAt),
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 12.0,
                              color: lightGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Your Appointment for',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 15.0,
                              color: darkText,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            snapshot.data![widget.index].serviceCategory.name
                                .toString(),
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 20.0,
                              color: darkText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          // Text(
                          //   'Water tap fix',
                          //   style: TextStyle(
                          //     fontFamily: 'Segoe UI',
                          //     fontSize: 12.0,
                          //     color: lightGrey,
                          //     fontWeight: FontWeight.w600,
                          //   ),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Date time',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 12.0,
                              color: lightGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            DateFormat('yyyy-MM-dd HH:mm')
                                .format(snapshot
                                    .data![widget.index].appointmentDateTime)
                                .toString(),
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 20.0,
                              color: darkText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          locationSection(
                              snapshot.data![widget.index].customerAddress
                                  .addressType
                                  .toString(),
                              snapshot
                                  .data![widget.index].customerAddress.address1
                                  .toString(),
                              snapshot
                                  .data![widget.index].customerAddress.address2
                                  .toString(),
                              snapshot.data![widget.index].customerAddress.city
                                  .toString()),
                          const SizedBox(
                            height: 20,
                          ),
                          budget(snapshot.data![widget.index].estimatedBudget
                              .toString()),
                          const SizedBox(
                            height: 20,
                          ),
                          additionalInfo(snapshot
                              .data![widget.index].addtionalInfo
                              .toString()),
                          const SizedBox(
                            //meka wenas kara
                            height: 80,
                          ),
                          RoundedButton(
                            buttonText: 'Submit Requests',
                            onPress: () {
                              if (checker != null && checker.isNotEmpty) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AppoinmentFirstTaskScreen(
                                          index: widget.index,
                                          quiedapooinment: true,
                                        )));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Center(
                                          child:
                                              Text("Please Add Your Address")),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddNewAdrressScreen(
                                                              desc:
                                                                  descriptionControlleer
                                                                      .text,
                                                              email:
                                                                  emailControlleer
                                                                      .text,
                                                              fullname:
                                                                  fullNameControlleer
                                                                      .text,
                                                              nic:
                                                                  NicControlleer
                                                                      .text,
                                                              providerid:
                                                                  providerid,
                                                              serviceid:
                                                                  ServicecatergoryIdControlleer
                                                                      .text,
                                                              phonenumber:
                                                                  phoneNumberControlleer
                                                                      .text,
                                                            )),
                                                    (route) => false);
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
    );
  }

  Widget locationSection(
      String addresstype, String address1, String address2, String city) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 15.0,
            color: darkText,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          addresstype,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 15.0,
            color: lightGrey,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          address1 + '\n' + address2 + '\n' + city,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 12.0,
            color: lightGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget budget(String budget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Budget',
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 15.0,
            color: darkText,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          'LKR ' + budget,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 20.0,
            color: lightGrey,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget additionalInfo(String additionalinformation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Information',
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 15.0,
            color: darkText,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        Text(
          additionalinformation,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 12.0,
            color: Color(0xFF828282),
          ),
        ),
      ],
    );
  }
}
