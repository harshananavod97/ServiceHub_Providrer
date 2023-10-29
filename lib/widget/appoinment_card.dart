import 'package:flutter/material.dart';

import 'package:servicehubprovider/utils/Colors.dart';
import 'package:servicehubprovider/screen/appoinments/PendingAppoinmentInfoScreen.dart';
import 'package:servicehubprovider/screen/appoinments/appoinment_info_screen.dart';
import 'package:servicehubprovider/screen/appoinments/past_appoinment_info_screen.dart';

class AppoinmentCard extends StatelessWidget {
  const AppoinmentCard(
      {super.key,
      required this.isPending,
      this.isPast = false,
      required this.date,
      required this.time,
      required this.addressType,
      required this.work,
      required this.price,
      required this.index});

  final bool isPending;
  final bool isPast;
  final String date;
  final String time;
  final String addressType;
  final String work;
  final String price;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isPast) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => PastAppoinmentInfoScreen(
                    index: index,
                  )));
        } else if (isPending) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => PendingAppoimentScreen(
                    index: index,
                  )));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AppoinmentInfoScreen(
                    index: index,
                  )));
        }
      },
      child: Container(
        height: 55,
        margin: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(9)),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: isPast ? darkText : kPrimary,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 12.0,
                            color: white,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 9.0,
                          color: white,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 10,
                          ),
                          Text(
                            addressType,
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 8.0,
                              color: white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                    color: greyColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            work,
                            style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 16.0,
                                color: darkText,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'LKR' + price,
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 10.0,
                              color: darkText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      isPending
                          ? Positioned(
                              right: 8,
                              top: 10,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 15, right: 15, top: 2, bottom: 2),
                                    child: isPast
                                        ? Text(
                                            "past",
                                            style: TextStyle(
                                              fontFamily: 'Segoe UI',
                                              fontSize: 8.0,
                                              color: darkText,
                                            ),
                                          )
                                        : Text(
                                            "pending",
                                            style: TextStyle(
                                              fontFamily: 'Segoe UI',
                                              fontSize: 8.0,
                                              color: darkText,
                                            ),
                                          ),
                                  )))
                          : const SizedBox()
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
