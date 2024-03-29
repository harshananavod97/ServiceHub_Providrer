import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:servicehubprovider/utils/Colors.dart';
import 'package:servicehubprovider/api/api_controller.dart';
import 'package:servicehubprovider/model/PendingAppoiments.dart';
import 'package:servicehubprovider/utils/constant.dart';
import 'package:servicehubprovider/widget/appoinment_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AllupcomingAppoinments extends StatefulWidget {
  const AllupcomingAppoinments({super.key});

  @override
  State<AllupcomingAppoinments> createState() => _AllupcomingAppoinmentsState();
}

class _AllupcomingAppoinmentsState extends State<AllupcomingAppoinments> {
  Apicontroller apicontroller = Apicontroller();
  
  List<PendingApoinmentList> pendingapoinmentlist = [];

  // get pending appoinments


  Future<List<PendingApoinmentList>> getPendingApoiment(String id) async {
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



  String providerid = "";
  String service_category_id = "";



  //load customer id  and service catergory id

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

    // print("my id is " + providerid);
    // print("my service is " + service_category_id);
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
      backgroundColor: white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upcoming Appoinments',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 20.0,
                    color: darkText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            FutureBuilder(
                future: getPendingApoiment(providerid.toString()),
                builder: (context,
                    AsyncSnapshot<List<PendingApoinmentList>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                        itemCount: pendingapoinmentlist.length,
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
