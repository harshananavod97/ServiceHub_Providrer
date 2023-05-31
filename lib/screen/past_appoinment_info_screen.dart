import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicehubprovider/api/api_controller.dart';
import 'package:servicehubprovider/model/PastAppoinments.dart';
import 'package:servicehubprovider/utils/constant.dart';
import 'package:servicehubprovider/widget/Rate_Experience.dart';
import 'package:servicehubprovider/widget/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:servicehubprovider/Colors.dart';

class PastAppoinmentInfoScreen extends StatefulWidget {
  const PastAppoinmentInfoScreen({super.key, required this.index});
  final int index;

  @override
  State<PastAppoinmentInfoScreen> createState() =>
      _PastAppoinmentInfoScreenState();
}

class _PastAppoinmentInfoScreenState extends State<PastAppoinmentInfoScreen> {
  String fcmkey = "";
  getcustomerdata() async {
    final customerdetails = await SharedPreferences.getInstance();
    setState(() {
      fcmkey = customerdetails.getString('fcm_key').toString();
    });
    print("fcm key is = " + fcmkey);
  }

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
          Padding(
            padding: EdgeInsets.only(top: 10, right: 25),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RatingScreen(
                        index: widget.index,
                      ),
                    ));
              },
              child: Text(
                'Rate Experince',
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 22.0,
                  color: kPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
          child: FutureBuilder(
            future: getpastappinments(providerid.toString()),
            builder: (context,
                    AsyncSnapshot<List<PastApoinmentList>> snapshot) =>
                pastapoinmentlist.isEmpty
                    ? const Center(child: CircularProgressIndicator())
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
                              DateFormat('yyyy-MM-dd HH:mm')
                                  .format(
                                      snapshot.data![widget.index].createdAt)
                                  .toString(),
                              style: const TextStyle(
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
                                color: darkText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Text(
                              snapshot.data![widget.index].serviceCategory.name
                                  .toString(),
                              style: const TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 20.0,
                                color: lightGrey,
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
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            const Text(
                              'Date Time',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 15.0,
                                color: darkText,
                                fontWeight: FontWeight.w700,
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
                              style: const TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 20.0,
                                color: lightGrey,
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
                                snapshot.data![widget.index].customerAddress
                                    .address1
                                    .toString(),
                                snapshot.data![widget.index].customerAddress
                                    .address2
                                    .toString(),
                                snapshot
                                    .data![widget.index].customerAddress.city
                                    .toString()),
                            const SizedBox(
                              height: 20,
                            ),
                            additionalInfo(snapshot
                                .data![widget.index].addtionalInfo
                                .toString()),
                            const SizedBox(
                              height: 20,
                            ),
                            snapshot.data![widget.index].jobPayment
                                        .paymentMethod !=
                                    "cash"
                                ? provider(
                                    snapshot.data![widget.index].serviceProvider
                                        .fullName
                                        .toString(),
                                    snapshot.data![widget.index].serviceProvider
                                        .email
                                        .toString(),
                                    snapshot.data![widget.index].serviceProvider
                                        .phoneNumber
                                        .toString())
                                : Container(),
                            const SizedBox(
                              height: 20,
                            ),
                            paymentInformation(
                              snapshot.data![widget.index].jobPayment
                                  .collectionStatus
                                  .toString(),
                              snapshot
                                  .data![widget.index].jobPayment.paymentMethod
                                  .toString(),
                              DateFormat('yyyy-MM-dd HH:mm')
                                  .format(snapshot.data![widget.index]
                                      .jobPayment.paymentDate)
                                  .toString(),
                            ),
                            snapshot.data![widget.index].jobPayment
                                        .paymentMethod ==
                                    "cash"
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      RoundedButton(
                                          buttonText: "Payment Confirm",
                                          onPress: () async {
                                            await apicontroller
                                                .getcustomerdetails(
                                              snapshot.data![widget.index]
                                                  .customerId
                                                  .toString(),
                                            );
                                            await apicontroller
                                                .getcustomerdetails(
                                              snapshot.data![widget.index]
                                                  .customerId
                                                  .toString(),
                                            );
                                            await getcustomerdata();

                                            apicontroller.SendPushNotification(
                                                fcmkey,
                                                "Cash Payment",
                                                "Aceept Your Cash Payment",
                                                "job");
                                            apicontroller
                                                .clientTosendCashAcceptMesage(
                                                    providerid, context);
                                          }),
                                    ],
                                  )
                                : SizedBox(),
                            const SizedBox(
                              height: 20,
                            ),
                          ]),
          )),
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

  Widget provider(
    String fullname,
    String email,
    String Phn_no,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Provider',
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
          fullname,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 15.0,
            color: lightGrey,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        Text(
          Phn_no,
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
          email,
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

  Widget paymentInformation(
      String PaymentStatus, String paymentType, String paymentDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Information',
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
          PaymentStatus,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 15.0,
            color: Color(0xFF828282),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          paymentType,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 12.0,
            color: Color(0xFF828282),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          paymentDate,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 12.0,
            color: Color(0xFF828282),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
