import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:servicehubprovider/Notifications/Notification_forground.dart';
import 'package:servicehubprovider/Notifications/getfcm.dart';
import 'package:servicehubprovider/api/api_controller.dart';

import 'package:servicehubprovider/firebase_options.dart';
import 'package:servicehubprovider/provider/auth_provider.dart';
import 'package:servicehubprovider/screen/NotificationScreen.dart';
import 'package:servicehubprovider/screen/TransactionScreen.dart';
import 'package:servicehubprovider/screen/cash_screen.dart';

import 'package:servicehubprovider/screen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
  Future.delayed(Duration(seconds: 1)).then((value) {
    if (message.notification?.title == "Cash Payment Request") {
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => CashScreen(),
        ),
      );
    }
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    //-------------------------------------------------------------------------------
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    final fcmToken = await FirebaseMessaging.instance.getToken();

    FirebaseMessaging.onMessage.listen((event) {
      print("onMessage fORGROUND ${event.data}");

      if (event.notification?.title == "Cash Payment Request") {
        Navigator.push(
          navigatorKey.currentState!.context,
          MaterialPageRoute(
            builder: (context) => CashScreen(),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("open it");

      print(message.notification?.title);

      Future.delayed(Duration(seconds: 1)).then((value) {
        if (message.notification?.title == "Cash Payment Request") {
          Navigator.push(
            navigatorKey.currentState!.context,
            MaterialPageRoute(
              builder: (context) => CashScreen(),
            ),
          );
        }
      });

      // onNotificationClicked(message, navigatorKey.currentState!.context);
    });
    final RemoteMessage? _message =
        await FirebaseMessaging.instance.getInitialMessage();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    runApp(
      MyApp(
        message: _message,
      ),
    );
  });
}

//Add the below lines of code after the main() method,
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatefulWidget {
  final RemoteMessage? message;
  const MyApp({super.key, this.message});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String providerid = "";
  String? fcmKey;

  getUserData() async {
    fcmKey = await getFcmToken();
    final ids = await SharedPreferences.getInstance();
    final idss = await SharedPreferences.getInstance();

    print("getcustomerdata called " + ids.getString('full_name').toString());
    setState(() {
      ids.getString("id").toString().isNotEmpty
          ? providerid = ids.getString("id").toString()
          : providerid = idss.getString("id").toString();
      apicontroller.getproviderdetails(providerid);

      apicontroller.ProviderFcmKeyUpdate(providerid, fcmKey.toString());
    });
  }

  Apicontroller apicontroller = Apicontroller();
  //fcm key genarate

  @override
  void initState() {
    // TODO: implement initState

    if (widget.message != null) {
      Future.delayed(const Duration(milliseconds: 2500)).then((value) {
        print(navigatorKey.currentState!.context);
      });
    } else {}

    getUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LocalNotification.initialize();
    // For Forground State
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotification.showNotification(message);
    });

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthProvider(),
          ),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const SplashScreen(),
        ));
  }
}
