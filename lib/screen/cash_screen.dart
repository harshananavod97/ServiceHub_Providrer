import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:servicehubprovider/api/api_controller.dart';
import 'package:servicehubprovider/model/PastAppoinments.dart';
import 'package:servicehubprovider/model/PendingAppoiments.dart';
import 'package:servicehubprovider/model/QuiedAppoiment.dart';
import 'package:servicehubprovider/screen/main_screen.dart';

import 'package:servicehubprovider/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:servicehubprovider/Colors.dart';
import 'package:servicehubprovider/widget/appoinment_card.dart';

class CashScreen extends StatefulWidget {
  CashScreen({
    super.key,
  });

  @override
  State<CashScreen> createState() => _CashScreenState();
}

class _CashScreenState extends State<CashScreen> {
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

  List<PastApoinmentList> pastapoinmentlist = [];
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
      print('load sucess');

      final appontment = pastApoinmentListFromJson(response.body);

      print("appointment " + appontment.length.toString());

      pastapoinmentlist.addAll(appontment);
      print(response.body);

      return pastapoinmentlist;
    } else {
      return pastapoinmentlist;

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
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                )),
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
      backgroundColor: white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cash Appointments',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 20.0,
                color: darkText,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 10,
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
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return snapshot
                                      .data![index].jobPayment.paymentMethod ==
                                  "cash"
                              ? AppoinmentCard(
                                  index: index,
                                  isPending: true,
                                  isPast: true,
                                  addressType: snapshot
                                      .data![index].customerAddress.addressType
                                      .toString(),
                                  date: DateFormat('yyyy-MM-dd ')
                                      .format(snapshot
                                          .data![index].appointmentDateTime)
                                      .toString(),
                                  price: snapshot.data![index].estimatedBudget
                                      .toString(),
                                  time: DateFormat('hh:mm')
                                      .format(snapshot
                                          .data![index].appointmentDateTime)
                                      .toString(),
                                  work: snapshot
                                      .data![index].serviceCategory.name
                                      .toString(),
                                )
                              : SizedBox();
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
