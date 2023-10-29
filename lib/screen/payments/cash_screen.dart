import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicehubprovider/api/api_controller.dart';
import 'package:servicehubprovider/model/PastAppoinments.dart';
import 'package:servicehubprovider/model/PendingAppoiments.dart';
import 'package:servicehubprovider/screen/Main%20Screens/Drawer.dart';
import 'package:servicehubprovider/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:servicehubprovider/utils/Colors.dart';
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

  //Get User iD
  getUserData() async {
    final ids = await SharedPreferences.getInstance();
    final idss = await SharedPreferences.getInstance();

    setState(() {
      ids.getString("id").toString().isNotEmpty
          ? providerid = ids.getString("id").toString()
          : providerid = idss.getString("id").toString();
    });

    apicontroller.getproviderdetails(providerid);
  }

//Get Past Appoinments

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

//Get Pending Appoinments

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
  void initState() {
    getUserData();
    super.initState();
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
                  builder: (context) => const MainScreen(),
                )),
          ),
        ),
        title: const Text('Back'),
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
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
                future: getpastappinments(providerid.toString()),
                builder:
                    (context, AsyncSnapshot<List<PastApoinmentList>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
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
                              : const SizedBox();
                        });
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return const Center(
                      child: Text(
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
