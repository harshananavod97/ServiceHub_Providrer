import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:servicehubprovider/Colors.dart';
import 'package:servicehubprovider/api/api_controller.dart';
import 'package:servicehubprovider/model/PastAppoinments.dart';
import 'package:servicehubprovider/model/TransactionDetails.dart';
import 'package:servicehubprovider/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              const Text(
                'Transactions',
                style: screenTitle,
              ),
              SizedBox(
                height: 20,
              ),
              TitleRow(),
              FutureBuilder(
                future: getpastappinments(providerid.toString()),
                builder:
                    (context, AsyncSnapshot<List<PastApoinmentList>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text("no any transaction"),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                SubTitle(
                                  text: snapshot.data![index].jobPayment.jobId
                                      .toString(),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SubTitle(
                                  text: DateFormat('yyyy-MM-dd')
                                      .format(snapshot
                                          .data![index].jobPayment.createdAt)
                                      .toString(),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SubTitle(
                                  text: snapshot
                                      .data![index].jobPayment.paidAmount
                                      .toString(),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Center(child: const CircularProgressIndicator()),
                    );
                  }
                },
              ),
            ]),
      ),
    );
  }
}

class SubTitle extends StatelessWidget {
  SubTitle({
    super.key,
    required this.text,
  });
  String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: navigationTop,
      width: 100,
      height: 30,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 15.0,
            color: lightText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class TitleRow extends StatelessWidget {
  const TitleRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleTable(
            text: "Job Id",
          ),
          SizedBox(
            width: 5,
          ),
          TitleTable(
            text: "Job Date",
          ),
          SizedBox(
            width: 5,
          ),
          TitleTable(
            text: "Payment",
          ),
        ],
      ),
    );
  }
}

class TitleTable extends StatelessWidget {
  TitleTable({
    super.key,
    required this.text,
  });
  String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: Colors.blue,
          width: 100,
          height: 30,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 15.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
      ],
    );
  }
}
