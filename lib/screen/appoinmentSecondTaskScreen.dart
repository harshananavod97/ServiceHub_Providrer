import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:servicehubprovider/Colors.dart';
import 'package:servicehubprovider/api/api_controller.dart';
import 'package:servicehubprovider/model/PastAppoinments.dart';
import 'package:servicehubprovider/model/PendingAppoiments.dart';
import 'package:servicehubprovider/model/QuiedAppoiment.dart';
import 'package:servicehubprovider/screen/appoinment_complete_screen.dart';
import 'package:servicehubprovider/styles.dart';
import 'package:servicehubprovider/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AppoinmentSecondTaskScreen extends StatefulWidget {
  AppoinmentSecondTaskScreen(
      {super.key,
      required this.date,
      required this.budget,
      required this.time,
      required this.index,
      required this.quiedappoiment});
  final String date, time, budget;
  int index;
  bool quiedappoiment;
  @override
  State<AppoinmentSecondTaskScreen> createState() =>
      _AppoinmentSecondTaskScreenState();
}

class _AppoinmentSecondTaskScreenState
    extends State<AppoinmentSecondTaskScreen> {
  String fcmkey = "";
  getcustomerdata() async {
    final customerdetails = await SharedPreferences.getInstance();
    setState(() {
      fcmkey = customerdetails.getString('fcm_key').toString();
    });
    print("fcm key is = " + fcmkey);
  }

  String providername = "";
  getproviderrdata() async {
    final providerdetails = await SharedPreferences.getInstance();
    setState(() {
      print(providerdetails.getString('full_name').toString());
      providerdetails != null && providerdetails.getString('full_name') != null
          ? providername = providerdetails.getString('full_name').toString()
          : providername = "Full name";
    });
  }

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

      service_category_id = idss.getString("servicecatergoryid").toString();
    });

    print("my id is " + providerid);
    print("my service is " + service_category_id);
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    getproviderrdata();

    super.initState();
  }

  Apicontroller apicontroller = Apicontroller();
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

  List<PendingApoinmentList> pendingapoinmentlist = [];
  Future<List<PendingApoinmentList>> getPendingApoiment(String id) async {
    pendingapoinmentlist.clear();
    var url = Uri.parse(
        // ignore: prefer_interpolation_to_compose_strings
        constant.APPEND_URL + "provider-pending-appointments?id=$id");
    final response = await http.get(url);
    print(response.body);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      print('load sucess');

      final appontment = pendingApoinmentListFromJson(response.body);

      print("appointment " + appontment.length.toString());

      pendingapoinmentlist.addAll(appontment);
      print(response.body);

      return pendingapoinmentlist;
    } else {
      return pendingapoinmentlist;

      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Styles.appBar(context),
        backgroundColor: white,
        body: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
            child: widget.quiedappoiment
                ? FutureBuilder(
                    future: getQueiedApoiment(service_category_id.toString()),
                    builder: (context,
                            AsyncSnapshot<List<QueiedApoinmentList>>
                                snapshot) =>
                        Stack(
                      children: [
                        apoinmentlist.isEmpty
                            ? Center(child: const CircularProgressIndicator())
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Confirm Info',
                                    style: screenTitle,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Your Appointment for',
                                    style: TextStyle(
                                      fontFamily: 'Segoe UI',
                                      fontSize: 12.0,
                                      color: lightGrey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    snapshot.data![widget.index].serviceCategory
                                        .name
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
                                    height: 18,
                                  ),
                                  Text(
                                    'Confirmed for',
                                    style: TextStyle(
                                      fontFamily: 'Segoe UI',
                                      fontSize: 12.0,
                                      color: lightGrey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    widget.date,
                                    style: TextStyle(
                                      fontFamily: 'Segoe UI',
                                      fontSize: 20.0,
                                      color: darkText,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    widget.time,
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
                                  locationSection(
                                      snapshot.data![widget.index]
                                          .customerAddress.addressType
                                          .toString(),
                                      snapshot.data![widget.index]
                                          .customerAddress.address1
                                          .toString(),
                                      snapshot.data![widget.index]
                                          .customerAddress.address2
                                          .toString(),
                                      snapshot.data![widget.index]
                                          .customerAddress.city
                                          .toString()),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  budget(widget.budget),
                                ],
                              ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: ElevatedButton(
                            onPressed: () async {
                              apicontroller.CreateRequest(
                                  providerid.toString(),
                                  snapshot.data![widget.index].id.toString(),
                                  widget.time,
                                  widget.budget,
                                  'Hire Me',
                                  context);

                              await apicontroller.getcustomerdetails(
                                snapshot.data![widget.index].customerId
                                    .toString(),
                              );

                              print("customer id is " +
                                  snapshot.data![widget.index].customerId
                                      .toString());

                              await getcustomerdata();

                              //send push notification for client reqest for job
                              //-==============================================================================================
                              apicontroller.SendPushNotification(
                                  fcmkey,
                                  "New Request For Job",
                                  providername + " request for your job",
                                  "job");
                              //========================================================================================
                            },
                            // ignore: sort_child_properties_last
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 8),
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: white),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: kPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(7), // <-- Radius
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : FutureBuilder(
                    future: getPendingApoiment(providerid.toString()),
                    builder: (context,
                            AsyncSnapshot<List<PendingApoinmentList>>
                                snapshot) =>
                        Stack(
                      children: [
                        pendingapoinmentlist.isEmpty
                            ? Center(child: const CircularProgressIndicator())
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Confirm Info',
                                    style: screenTitle,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Your Appointment for',
                                    style: TextStyle(
                                      fontFamily: 'Segoe UI',
                                      fontSize: 12.0,
                                      color: lightGrey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    snapshot.data![widget.index].serviceCategory
                                        .name
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
                                    height: 18,
                                  ),
                                  Text(
                                    'Confirmed for',
                                    style: TextStyle(
                                      fontFamily: 'Segoe UI',
                                      fontSize: 12.0,
                                      color: lightGrey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    widget.date,
                                    style: TextStyle(
                                      fontFamily: 'Segoe UI',
                                      fontSize: 20.0,
                                      color: darkText,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    widget.time,
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
                                  locationSection(
                                      snapshot.data![widget.index]
                                          .customerAddress.addressType
                                          .toString(),
                                      snapshot.data![widget.index]
                                          .customerAddress.address1
                                          .toString(),
                                      snapshot.data![widget.index]
                                          .customerAddress.address2
                                          .toString(),
                                      snapshot.data![widget.index]
                                          .customerAddress.city
                                          .toString()),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  budget(widget.budget),
                                ],
                              ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (BuildContext context) =>
                              //         const AppoinmentCompleteScreen()));\\
//******************************************************************************************************************************************** */
//dought have
                              // apicontroller.UpadateRequest(
                              //     snapshot.data![widget.index].jobRequest.id
                              //             .toString()
                              //             .isEmpty
                              //         ? "0"
                              //         : snapshot
                              //             .data![widget.index].jobRequest.id
                              //             .toString(),
                              //     providerid.toString(),
                              //     snapshot.data![widget.index].id.toString(),
                              //     widget.time,
                              //     widget.budget,
                              //     'jj',
                              //     'selected',
                              //     context);
                              // apicontroller.updateProviderDetails(id, full_name, email, phone_number, nic, address_1, address_2, city, service_category_id, description, password, context)
                            },
                            // ignore: sort_child_properties_last
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 8),
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: white),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: kPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(7), // <-- Radius
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )));
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
        Text(
          'Confirmed budget',
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 12.0,
            color: lightGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'LKR ' + double.parse(budget).toStringAsFixed(2),
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 20.0,
            color: Color(0xFF828282),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
