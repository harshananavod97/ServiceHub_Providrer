import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:servicehubprovider/Colors.dart';
import 'package:servicehubprovider/api/api_controller.dart';
import 'package:servicehubprovider/model/PastAppoinments.dart';
import 'package:servicehubprovider/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:http/http.dart' as http;

class RatingScreen extends StatefulWidget {
  RatingScreen({
    required this.index,
    super.key,
  });
  int index;
  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  String providerid = "";
  Apicontroller apicontroller = Apicontroller();
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

  final commentControlleer = TextEditingController();
  final commentFocusNode = FocusNode();

  var rating = 0.0;

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
        ),
        body:
            // render the UI when data is available
            Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: getpastappinments(providerid.toString()),
              builder: (context,
                      AsyncSnapshot<List<PastApoinmentList>> snapshot) =>
                  pastapoinmentlist.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Rating',
                              style: screenTitle,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: CircleAvatar(
                                radius: 75,
                                backgroundColor: kPrimary,
                                child: ClipOval(
                                  child: SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: snapshot.data![widget.index]
                                                .serviceProvider.profilePic ==
                                            null
                                        ? Text('No Image')
                                        : Image.network(
                                            'https://servicehub.clickytesting.xyz/' +
                                                snapshot.data![widget.index]
                                                    .serviceProvider.profilePic
                                                    .toString(),
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            snapshot.data![widget.index].jobRating.toString() ==
                                    "No rating available"
                                ? Center(
                                    child: Text(
                                      'Not Give Any Rating ',
                                      style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 15.0,
                                        color: darkText,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: SmoothStarRating(
                                        allowHalfRating: false,
                                        onRatingChanged: (v) {
                                          setState(() {});
                                        },
                                        starCount: snapshot.data![widget.index]
                                                    .jobRating
                                                    .toString() ==
                                                "No rating available"
                                            ? 0
                                            : snapshot.data![widget.index]
                                                .jobRating['rating'],
                                        rating: 5.0,
                                        size: 30.0,
                                        filledIconData: Icons.star,
                                        halfFilledIconData: Icons.blur_on,
                                        color: Colors.red,
                                        borderColor: darkText,
                                        spacing: 0.0),
                                  ),
                            const SizedBox(
                              height: 20,
                            ),
                            snapshot.data![widget.index].jobRating.toString() ==
                                    "No rating available"
                                ? Container()
                                : Column(
                                    children: [
                                      Text(
                                        'comment : ',
                                        style: TextStyle(
                                          fontFamily: 'Segoe UI',
                                          fontSize: 15.0,
                                          color: darkText,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                            snapshot.data![widget.index].jobRating.toString() ==
                                    "No rating available"
                                ? Container()
                                : Container(
                                    height: 150,
                                    width: double.infinity,
                                    color: inputFieldBackgroundColor,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        snapshot.data![widget.index]
                                            .jobRating['comment'],
                                        style: TextStyle(
                                            fontFamily: 'Segoe UI',
                                            fontSize: 20,
                                            color: lightText),
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              height: 60,
                            ),
                          ],
                        ),
            ),
          ),
        ));
  }
}
