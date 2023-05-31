import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:servicehubprovider/Colors.dart';
import 'package:servicehubprovider/api/api_controller.dart';
import 'package:servicehubprovider/model/PendingAppoiments.dart';
import 'package:servicehubprovider/model/QuiedAppoiment.dart';
import 'package:servicehubprovider/screen/appoinment_first_task_screen.dart';
import 'package:servicehubprovider/Notifications/getfcm.dart';
import 'package:servicehubprovider/utils/constant.dart';
import 'package:servicehubprovider/widget/rounded_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PendingAppoimentScreen extends StatefulWidget {
  PendingAppoimentScreen({super.key, required this.index});
  int index;

  @override
  State<PendingAppoimentScreen> createState() => _PendingAppoimentScreenState();
}

class _PendingAppoimentScreenState extends State<PendingAppoimentScreen> {
  String fcmkey = "";
  getcustomerdata() async {
    final customerdetails = await SharedPreferences.getInstance();
    setState(() {
      fcmkey = customerdetails.getString('fcm_key').toString();
    });
  }

  void _incrementCounter() async {
    String? fcmKey = await getFcmToken();
    print('FCM Key : $fcmKey');
  }

  Position? currentPosition;
  Apicontroller apicontroller = Apicontroller();

  String providerid = "";
  getUserData() async {
    final ids = await SharedPreferences.getInstance();
    final idss = await SharedPreferences.getInstance();

    print("getcustomerdata called " + ids.getString('full_name').toString());
    setState(() {
      ids.getString("id").toString().isNotEmpty
          ? providerid = ids.getString("id").toString()
          : providerid = idss.getString("id").toString();
    });

    print("my id is " + providerid);

    apicontroller.getproviderdetails(providerid);
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
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
        actions: [
          FutureBuilder(
            future: getPendingApoiment(providerid.toString()),
            builder:
                (context, AsyncSnapshot<List<PendingApoinmentList>> snapshot) =>
                    InkWell(
              onTap: () async {
                apicontroller.Providerremovehimself(
                    snapshot.data![widget.index].jobRequest.jobId.toString(),
                    context);

                await apicontroller.getcustomerdetails(
                  snapshot.data![widget.index].customerId.toString(),
                );

                await getcustomerdata();

                //send push notification for client reqest for job
                //-==============================================================================================
                apicontroller.SendPushNotification(
                    fcmkey, "Cancle The Job", "Cancle  job", 'no');
                //========================================================================================
              },
              child: Padding(
                padding: EdgeInsets.only(top: 10, right: 25),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 22.0,
                    color: Color(0xFFEA4600),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
        child: FutureBuilder(
          future: getPendingApoiment(providerid.toString()),
          builder: (context,
                  AsyncSnapshot<List<PendingApoinmentList>> snapshot) =>
              pendingapoinmentlist.isEmpty
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
                            buttonText: 'Start Navigation',
                            onPress: () async {
                              ///************************************************************
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (BuildContext context) =>
                              //         AppoinmentFirstTaskScreen(
                              //           index: widget.index,
                              //           quiedapooinment: false,
                              //         )));
                              //********************************************************************** */
                              final String latitude = snapshot
                                  .data![widget.index].customerAddress.lat;
                              final String longitude = snapshot
                                  .data![widget.index].customerAddress.ing;

                              print("lat is" +
                                  snapshot
                                      .data![widget.index].customerAddress.lat);
                              String url =
                                  'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving';
                              url = url.replaceFirst('latitude',
                                  currentPosition?.latitude.toString() ?? '');
                              url = url.replaceFirst('longitude',
                                  currentPosition?.longitude.toString() ?? '');
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
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
