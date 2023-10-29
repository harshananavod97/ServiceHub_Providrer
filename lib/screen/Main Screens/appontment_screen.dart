import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:servicehubprovider/api/api_controller.dart';
import 'package:servicehubprovider/model/PastAppoinments.dart';
import 'package:servicehubprovider/model/PendingAppoiments.dart';
import 'package:servicehubprovider/model/QuiedAppoiment.dart';
import 'package:servicehubprovider/screen/Main%20Screens/Drawer.dart';

import 'package:servicehubprovider/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:servicehubprovider/utils/Colors.dart';
import 'package:servicehubprovider/widget/appoinment_card.dart';

class AppointmentScreen extends StatefulWidget {
  AppointmentScreen({super.key, required this.swiched});
  bool swiched;

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  Apicontroller apicontroller = Apicontroller();

  String providerid = "";

//Load Prider Id

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

  List<PastApoinmentList> pastapoinmentlist = [];
//Load completed Appoinments

  Future<List<PastApoinmentList>> getpastappinments(String id) async {
    pastapoinmentlist.clear();
    var url = Uri.parse(
        // ignore: prefer_interpolation_to_compose_strings
        constant.APPEND_URL + "provider-completed-appointments?id=$id");
    final response = await http.get(url);
    print(response.body);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      // print('load sucess');

      final appontment = pastApoinmentListFromJson(response.body);

      // print("appointment " + appontment.length.toString());

      pastapoinmentlist.addAll(appontment);
      print(response.body);

      return pastapoinmentlist;
    } else {
      return pastapoinmentlist;

      throw Exception('Failed to load data');
    }
  }

  List<PendingApoinmentList> pendingapoinmentlist = [];

//Load Pending Appoinments

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
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.swiched
          ? AppBar(
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
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      )),
                ),
              ),
              title: const Text('Back'),
              actions: const [],
            )
          : null,
      backgroundColor: white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.swiched
                ? SizedBox(
                    height: 0,
                  )
                : SizedBox(
                    height: 40,
                  ),
            const Text(
              'My Appoinments',
              style: screenTitle,
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder(
                future: getPendingApoiment(providerid.toString()),
                builder: (context,
                    AsyncSnapshot<List<PendingApoinmentList>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: const CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final itemCount =
                        snapshot.data!.length > 5 ? 5 : snapshot.data!.length;
                    return ListView.builder(
                        itemCount: itemCount,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AppoinmentCard(
                            index: index,
                            isPending: true,
                            addressType: snapshot
                                .data![index].customerAddress.addressType
                                .toString(),
                            date: DateFormat('yyyy-MM-dd ')
                                .format(
                                    snapshot.data![index].appointmentDateTime)
                                .toString(),
                            price: snapshot.data![index].estimatedBudget
                                .toString(),
                            time: DateFormat('hh:mm').format(
                                snapshot.data![index].appointmentDateTime),
                            work: snapshot.data![index].serviceCategory.name
                                .toString(),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return Center(
                      child: const Text(
                        "No available data",
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 15.0,
                          color: darkText,
                        ),
                      ),
                    );
                  }
                }),
            const SizedBox(
              height: 27,
            ),
            const Text(
              'Past Appointments',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 20.0,
                color: darkText,
                fontWeight: FontWeight.w700,
              ),
            ),
            FutureBuilder(
                future: getpastappinments(providerid.toString()),
                builder:
                    (context, AsyncSnapshot<List<PastApoinmentList>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: const CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final itemCount =
                        snapshot.data!.length > 5 ? 5 : snapshot.data!.length;
                    return ListView.builder(
                        itemCount: itemCount,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AppoinmentCard(
                            index: index,
                            isPending: true,
                            isPast: true,
                            addressType: snapshot
                                .data![index].customerAddress.addressType
                                .toString(),
                            date: DateFormat('yyyy-MM-dd ')
                                .format(
                                    snapshot.data![index].appointmentDateTime)
                                .toString(),
                            price: snapshot.data![index].estimatedBudget
                                .toString(),
                            time: DateFormat('hh:mm')
                                .format(
                                    snapshot.data![index].appointmentDateTime)
                                .toString(),
                            work: snapshot.data![index].serviceCategory.name
                                .toString(),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return Center(
                      child: const Text(
                        "No available data",
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 15.0,
                          color: darkText,
                        ),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
