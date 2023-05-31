import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:servicehubprovider/Colors.dart';
import 'package:servicehubprovider/api/api_controller.dart';
import 'package:servicehubprovider/model/QuiedAppoiment.dart';
import 'package:servicehubprovider/utils/constant.dart';
import 'package:servicehubprovider/widget/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppoinmentInfo2Screen extends StatefulWidget {
  const AppoinmentInfo2Screen({super.key, required this.quiedappoinment});
  final bool quiedappoinment;

  @override
  State<AppoinmentInfo2Screen> createState() => _AppoinmentInfo2ScreenState();
}

class _AppoinmentInfo2ScreenState extends State<AppoinmentInfo2Screen> {
  Apicontroller apicontroller = Apicontroller();

  String providerid = "";
  getUserData() async {
    final ids = await SharedPreferences.getInstance();
    final idss = await SharedPreferences.getInstance();

    print("getcustomerdata called " + ids.getString('full_name').toString());

    ids.getString("id").toString().isNotEmpty
        ? providerid = ids.getString("id").toString()
        : providerid = idss.getString("id").toString();

    print("my id is " + providerid);
    apicontroller.getproviderdetails(providerid);
  }

  @override
  void initState() {
    // TODO: implement initState
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
          Padding(
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
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            'Appointment Info',
            style: screenTitle,
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            'Confirmed on 9 June 2020 11:40 am',
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
            'Plumbing works',
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
          Text(
            'Water tap fix',
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
            'June 12 2020 10:00 am',
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
          locationSection(),
          const SizedBox(
            height: 20,
          ),
          budget(),
          const SizedBox(
            height: 20,
          ),
          additionalInfo(),
          const SizedBox(
            height: 43,
          ),
          RoundedButton(
            buttonText: 'Start Navigation',
            onPress: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (BuildContext context) => const RegisterScreen()));
            },
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  Widget locationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Locaion',
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
          'Home',
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 15.0,
            color: darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          '21, Passara Road\nHindagoda\nBadulla',
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 12.0,
            color: lightGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget budget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Budget',
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
          'LKR 1500',
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

  Widget additionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Additional Information',
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 12.0,
            color: lightGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 7,
        ),
        Text(
          'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero\'s De Finibus Bonorum et Malorum for use in a type specimen book.',
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 12.0,
            color: Color(0xFF828282),
          ),
        ),
      ],
    );
  }
}
