import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:servicehubprovider/utils/Colors.dart';
import 'package:servicehubprovider/api/api_controller.dart';
import 'package:servicehubprovider/model/QuiedAppoiment.dart';
import 'package:servicehubprovider/utils/constant.dart';
import 'package:servicehubprovider/widget/appoinment_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AllnewAppoinments extends StatefulWidget {
  const AllnewAppoinments({super.key});

  @override
  State<AllnewAppoinments> createState() => _AllnewAppoinmentsState();
}

class _AllnewAppoinmentsState extends State<AllnewAppoinments> {
  Apicontroller apicontroller = Apicontroller();

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

    print("my id is " + providerid);
    print("my service is " + service_category_id);
  }


 List<QueiedApoinmentList> apoinmentlist = [];

//get all new appoinments

 
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
  void initState() {
    // TODO: implement initState
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
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text('Back'),
        actions: const [
      
        ],
      ),
      backgroundColor: white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'New requests',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 20.0,
                    color: darkText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            FutureBuilder(
                future: getQueiedApoiment(service_category_id.toString()),
                builder: (context,
                    AsyncSnapshot<List<QueiedApoinmentList>> snapshot) {
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
                          return AppoinmentCard(
                            index: index,
                            isPending: false,
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
          ],
        ),
      ),
    );
  }
}
