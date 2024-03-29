import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicehubprovider/utils/Colors.dart';
import 'package:servicehubprovider/Notifications/Notification_forground.dart';
import 'package:servicehubprovider/api/api_controller.dart';
import 'package:servicehubprovider/screen/payments/TransactionScreen.dart';
import 'package:servicehubprovider/screen/Main%20Screens/appontment_screen.dart';
import 'package:servicehubprovider/screen/Main%20Screens/contact_screen.dart';
import 'package:servicehubprovider/screen/Main%20Screens/faq_screen.dart';
import 'package:servicehubprovider/screen/Main%20Screens/home_screen.dart';
import 'package:servicehubprovider/screen/onborading%20Screens/login_screen.dart';
import 'package:servicehubprovider/screen/profile/profile_screen.dart';
import 'package:servicehubprovider/screen/Main%20Screens/terms_condition_screen.dart';
import 'package:servicehubprovider/widget/app_name_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/auth_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;
  String name = '';
  List<Widget> list = [
    const HomeScreen(),
    AppointmentScreen(
      swiched: false,
    ),
    const ProfileScreen(),
    const ContactScreen(),
    const FaqScreen(),
    const TermsConditionScreen(),
    const LoginScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: index == 0 ? navigationTop : white,
          foregroundColor: darkText,
          title: index == 0 ? const Text("Servicehub") : const Text(""),
        ),
        body: list[index],
        drawer: const MyDrawer());
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {


   Apicontroller apicontroller = Apicontroller();
  final fullNameControlleer = TextEditingController();


  String customerid = '';
  String fullname = '';
  bool islog = false;
  String id = '';
  

//user id get api
  getUserData() async {
    final ids = await SharedPreferences.getInstance();
    final idss = await SharedPreferences.getInstance();

    print("getcustomerdata called " + ids.getString('full_name').toString());

    ids.getString("id").toString().isNotEmpty
        ? customerid = ids.getString("id").toString()
        : customerid = idss.getString("id").toString();

    print("my id is" + customerid);
  }

  getcustomerdata() async {
    final customerdetails = await SharedPreferences.getInstance();

    setState(() {
      fullname = customerdetails.getString('full_name').toString() != null
          ? fullname = customerdetails.getString('full_name').toString()
          : fullname = "User Name";
    });
  }
 
 
  @override
  void initState() {
    looged();
    getUserData();
    getcustomerdata();

    super.initState();
  }

  looged() async {
    final prefs = await SharedPreferences.getInstance();

    bool? islog = prefs.getBool('isLogged');
    print(prefs.getBool('isLogged'));
  }

  @override
  Widget build(BuildContext context) {
    // For Forground State
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotification.showNotification(message);
    });

    return SafeArea(
      child: Drawer(
        backgroundColor: white,
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.only(left: 35, top: 20),
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppNameWidget(),
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    "Hey",
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 20,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    fullname,
                    style: const TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 25,
                        color: darkText,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(
                height: 45,
              ),
              ListTile(
                leading: const Icon(Icons.home, color: kPrimary),
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 5,
                title: const Text(
                  "Home",
                  style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 22,
                      color: darkText,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    )),
              ),
              ListTile(
                leading: const Icon(Icons.list, color: kPrimary),
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 5,
                title: const Text(
                  "Appoinments",
                  style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 22,
                      color: darkText,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentScreen(
                        swiched: false,
                      ),
                    )),
              ),
              ListTile(
                  leading: const Icon(Icons.person, color: kPrimary),
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 5,
                  title: const Text(
                    "My Profile",
                    style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 22,
                        color: darkText,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ));
                  }),
              ListTile(
                  leading: const Icon(Icons.mail, color: kPrimary),
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 5,
                  title: const Text(
                    "Contact us",
                    style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 22,
                        color: darkText,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContactScreen(),
                      ))),
              ListTile(
                  leading: const Icon(Icons.money, color: kPrimary),
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 5,
                  title: const Text(
                    "Transaction",
                    style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 22,
                        color: darkText,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TransactionScreen(),
                        ));
                  }),
              ListTile(
                leading: const Icon(Icons.message, color: kPrimary),
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 5,
                title: const Text(
                  "FAQs",
                  style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 22,
                      color: darkText,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FaqScreen(),
                    )),
              ),
              ListTile(
                leading:
                    const Icon(Icons.content_paste_outlined, color: kPrimary),
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 5,
                title: const Text(
                  "Terms & Conditions",
                  style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 22,
                      color: darkText,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsConditionScreen(),
                    )),
              ),
              ListTile(
                  leading: const Icon(Icons.logout, color: kPrimary),
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 5,
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 22,
                        color: darkText,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () async {
                    // ignore: use_build_context_synchronously

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false);
                    final prefs = await SharedPreferences.getInstance();
                    prefs.clear();

                    Provider.of<AuthProvider>(context, listen: false)
                        .logout(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
