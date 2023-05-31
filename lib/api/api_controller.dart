// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:servicehubprovider/screen/appoinment_complete_screen.dart';

import 'package:servicehubprovider/screen/login_screen.dart';
import 'package:servicehubprovider/screen/main_screen.dart';
import 'package:servicehubprovider/utils/Navigation_Function.dart';
import 'package:servicehubprovider/utils/constant.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../screen/verification_screen.dart';

class Apicontroller {
  // ignore: duplicate_ignore
  register(
      String email,
      full_name,
      phone_number,
      city,
      service_category_id,
      description,
      addres1,
      address2,
      nic,
      password,
      fcm,
      BuildContext context) async {
    // final details = await SharedPreferences.getInstance();
    // final detailss = await SharedPreferences.getInstance();

    Map data = {
      'email': email,
      'phone_number': phone_number,
      'full_name': full_name,
      'address_1': addres1,
      'address_2': address2,
      'city': city,
      'service_category_id': service_category_id,
      'description': description,
      'nic': nic,
      'password': password,
      'fcm_key': fcm
    };

    // ignore: avoid_print
    print("post data $data");

    String body = json.encode(data);
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + "provider-register");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    // ignore: avoid_print
    print(response.body);
    print(response.statusCode);
    var jsonData = jsonDecode(response.body);
    // await details.setString('email', email);
    // await details.setString('phone_number', phone_number);
    // await details.setString('full_name', full_name);

    if (response.statusCode == 200) {
      Logger().i('success custom login');
      // Save an String value to 'action' key.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("Your Registration Successful ")),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  NavigationUtillfunction.navigateTo(
                      context, const LoginScreen());
                },
              ),
            ],
          );
        },
      );
      // ignore: use_build_context_synchronously
    } else {
      Logger().i("error");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("Your are not Register ")),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  NavigationUtillfunction.navigateTo(
                      context, const LoginScreen());
                },
              ),
            ],
          );
        },
      );
    }
  }

  getproviderdetails(String id) async {
    final providerdetails = await SharedPreferences.getInstance();
    //replace your restFull API here.
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + 'provider?id=$id');
    final response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);

    var responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);
    String fullname,
        email,
        phonenumber,
        nic,
        address1,
        address2,
        city,
        servicecatergoryid,
        description,
        profilepic,
        lat,
        long;
    fullname = jsonResponse['full_name'].toString();
    email = jsonResponse['email'].toString();
    phonenumber = jsonResponse['phone_number'].toString();
    nic = jsonResponse['nic'].toString();
    address1 = jsonResponse['address_1'].toString();
    address2 = jsonResponse['address_2'].toString();
    city = jsonResponse['city'].toString();
    servicecatergoryid = jsonResponse['service_category_id'].toString();
    profilepic = jsonResponse['profile_pic'].toString();
    description = jsonResponse['description'].toString();
    lat = jsonResponse['lat'].toString();
    long = jsonResponse['long'].toString();

    await providerdetails.setString('full_name', fullname);
    await providerdetails.setString('email', email);
    await providerdetails.setString('phone_number', phonenumber);
    await providerdetails.setString('profile_pic', profilepic);
    await providerdetails.setString('lat', lat);
    await providerdetails.setString('ing', long);

    await providerdetails
      ..setString('nic', nic);
    await providerdetails
      ..setString('address1', address1);
    await providerdetails
      ..setString('address2', address2);
    await providerdetails
      ..setString('city', city);
    await providerdetails
      ..setString('servicecatergoryid', servicecatergoryid);
    await providerdetails
      ..setString('description', description);
    print(providerdetails.getString('full_name'));
    print(email);
    print(phonenumber);

    //Creating a list to store input data;

    //get customer details  (my profile read only)
    getcustomerdetails(String id, BuildContext context) async {
      final customerdetails = await SharedPreferences.getInstance();
      final prefs = await SharedPreferences.getInstance();

      //replace your restFull API here.
      // ignore: prefer_interpolation_to_compose_strings
      var url = Uri.parse(constant.APPEND_URL + 'customer?id=$id');
      final response = await http.get(url);
      var jsonResponse = jsonDecode(response.body);

      var responseData = json.decode(response.body);
      print(response.body);
      print(response.statusCode);
      String fcmkey;

      fcmkey = jsonResponse['fcm_key'].toString();

      await customerdetails.setString('fcm_key', fcmkey);
    }
  }

  updateProviderDetails(
      String id,
      String full_name,
      String email,
      String phone_number,
      String nic,
      String address_1,
      String address_2,
      String city,
      String service_category_id,
      String description,
      String password,
      String lat,
      String long,
      BuildContext context) async {
    Map data = {
      "id": id,
      "full_name": full_name,
      "email": email,
      "phone_number": phone_number,
      "nic": nic,
      "address_1": address_1,
      "address_2": address_2,
      "city": city,
      "service_category_id": service_category_id,
      "description": description,
      "password": password,
      "ing": long,
      "lat": lat
    };
    print("post data $data");
    final ids = await SharedPreferences.getInstance();

    String body = json.encode(data);
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + "provider-update");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      getproviderdetails(id.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("Sucessfully Updated")),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ));
                },
              ),
            ],
          );
        },
      );

      Logger().i('update sucess');
    } else {
      Logger().i('error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("Your Update Unsuccessful ")),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  NavigationUtillfunction.navigateTo(
                      context, const MainScreen());
                },
              ),
            ],
          );
        },
      );
      // NavigationUtillfunction.navigateTo(context, MainScreen());
    }
  }

  fbgoogleregister(
      String email,
      full_name,
      phone_number,
      city,
      service_category_id,
      description,
      addres1,
      address2,
      nic,
      password,
      BuildContext context) async {
    final ids = await SharedPreferences.getInstance();
    final customerdetails = await SharedPreferences.getInstance();

    String customerid = await ids.getString("id").toString();
    Map data = {
      'email': email,
      'phone_number': phone_number,
      'full_name': full_name,
      'address_1': addres1,
      'address_2': address2,
      'city': city,
      'service_category_id': service_category_id,
      'description': description,
      'nic': nic,
      'password': password,
    };

    print("post data $data");

    String body = json.encode(data);
    var url = Uri.parse(constant.APPEND_URL + "provider-register");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(jsonData["0"].toString());

      final Map<String, dynamic> job = jsonData["0"];
      await ids.setString('id', job['id'].toString());
      // await ids.setString('full_name', job['full_name'].toString());
      await ids.setString('full_name', full_name);

      await customerdetails.setString('phone_number', phone_number);

      print("id " + job['id'].toString());

      //otp genarate
      otpgenarate(phone_number, context);

      Logger().i('facebook google login');
      // Save an String value to 'action' key.

      // ignore: use_build_context_synchronously

      NavigationUtillfunction.navigateTo(
          context,
          VerificationScreen(
            userId: job['id'].toString(),
            PhoneNumber: phone_number,
          ));
    } else {
      Logger().e('error');
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("Number Allready Used")),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                },
              ),
            ],
          );
        },
      );
    }
  }

//otp genrate
  otpgenarate(String phone_number, BuildContext context) async {
    final idss = await SharedPreferences.getInstance();
    Map data = {
      'phone_number': phone_number,
    };
    print("post data $data");

    String body = json.encode(data);
    var url = Uri.parse(constant.APPEND_URL + "otp-provider");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      jsonResponse.toString();

      Logger().i("user id " + jsonResponse['id'].toString());
      await idss.setString('id', jsonResponse['id'].toString());

      Logger().i('otp sucess');
      NavigationUtillfunction.navigateTo(
          context,
          VerificationScreen(
            userId: jsonResponse['id'].toString(),
            PhoneNumber: phone_number,
          ));

      getproviderdetails(jsonResponse['id'].toString());

      print("user id is : ${jsonResponse['id']}");
      // ignore: use_build_context_synchronously
    } else {
      var errorJson = jsonDecode(response.body);
      Logger().e('error');
      var errorMessage = errorJson['message'];

      if (errorMessage == "provider is not approved yet") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("provider is not approved yet"),
              actions: <Widget>[
                ElevatedButton(
                  child: Center(child: const Text('OK')),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("you are not registered"),
              actions: <Widget>[
                ElevatedButton(
                  child: Center(child: const Text('OK')),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

//"Validate OTP
  validateotp(String id, String otp, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    Map data = {
      "id": id,
      'otp': otp,
    };
    print("post data $data");

    String body = json.encode(data);
    var url = Uri.parse(constant.APPEND_URL + "provide-validate-otp");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      await prefs.setBool('isLogged', true);
      //Or put here your next screen using Navigator.push() method
      Logger().i('validate sucess');
      // ignore: unused_local_variable
      var jsonResponse = jsonDecode(response.body);
      // print("user id ${jsonResponse['id']}");
      // await prefs.setString('id', id);
      //  await prefs.setBool('isLogged', true);

      // ignore: use_build_context_synchronously

      // await getcustomerdetails(id);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false);
    } else {
      Logger().e('error');

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Enter Correct OTP'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  CreateRequest(String service_provider_id, job_id, estimated_time,
      estimated_budget, comment, BuildContext context) async {
    Map data = {
      'service_provider_id': service_provider_id,
      'job_id': job_id,
      'estimated_time': estimated_time,
      'estimated_budget': estimated_budget,
      'comment': comment,
    };

    print("post data $data");

    String body = json.encode(data);
    var url = Uri.parse(constant.APPEND_URL + "create-request");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(jsonData["0"].toString());

      Logger().i('Request Sucessfully');
      // Save an String value to 'action' key.
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const AppoinmentCompleteScreen()));

      // ignore: use_build_context_synchronously
    } else {
      Logger().e('error');
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("Request Unsucessfully")),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  UpadateRequest(String id, service_provider_id, job_id, estimated_time,
      estimated_budget, comment, approval, BuildContext context) async {
    Map data = {
      'id': id,
      'service_provider_id': service_provider_id,
      'job_id': job_id,
      'estimated_time': estimated_time,
      'estimated_budget': estimated_budget,
      'comment': comment,
      'approval': approval
    };

    print("post data $data");

    String body = json.encode(data);
    var url = Uri.parse(constant.APPEND_URL + "update-request");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(jsonData["0"].toString());

      Logger().i('Request update Sucessfully');
      // Save an String value to 'action' key.
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const AppoinmentCompleteScreen()));
      // ignore: use_build_context_synchronously
    } else {
      Logger().e('error');
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("Request  Update Failled")),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  SendPushNotification(
      String fcmkey, String title, String message, type) async {
    Map data = {
      'to': fcmkey,
      'title': title,
      'notification': {
        "type": type,
        'body': message,
      },
    };
    print("post data $data");

    String body = json.encode(data);
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAjZj7qC8:APA91bFiqqBL9JdvKit7G1gD-p57QNvaEaRNC4dhLGSgFyOyGWR-4Ti3HuNujwRFO6ch29HMY2md_J42rmYNBTRn0epMdnSJxLydnGn44fYlnHU05uIG9kTZWC97CMe8YMS0JYDUhbyz",
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      //Or put here your next screen using Navigator.push() method
      Logger().i('Push Notification Sucessfully');
    } else {
      Logger().e('error');
    }
  }

//provider Remove Him Self

  Future<void> Providerremovehimself(String id, BuildContext context) async {
    final url =
        Uri.parse(constant.APPEND_URL + 'remove-provider-by-himself?id=$id');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      print('Request deleted successfully.');
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
    } else {
      print('Failed to delete request.');
    }
  }

  ProviderFcmKeyUpdate(String provider_id, String fcm_key) async {
    Map data = {'provider_id': provider_id, 'fcm_key': fcm_key};
    print("post data $data");

    String body = json.encode(data);
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + "update-provider-fcm-key");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      //Or put here your next screen using Navigator.push() method
      Logger().i('Push Notification Sucessfully');
    } else {
      Logger().e('error');
    }
  }

//"Cash AceeptMessage"
  clientTosendCashAcceptMesage(String id, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    Map data = {
      "id": id,
    };
    print("post data $data");

    String body = json.encode(data);
    var url =
        Uri.parse(constant.APPEND_URL + "provider-cash-accept-sms?id=$id");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      await prefs.setBool('isLogged', true);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ));

      Logger().i('Send Cash Message');

      var jsonResponse = jsonDecode(response.body);
    } else {
      Logger().e('error');

      // ignore: use_build_context_synchronously
    }
  }

  getcustomerdetails(String id) async {
    final customerdetails = await SharedPreferences.getInstance();

    //replace your restFull API here.
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + 'customer?id=$id');
    final response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);

    var responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);
    String fcm_key;

    fcm_key = jsonResponse['fcm_key'].toString();

    await customerdetails.setString('fcm_key', fcm_key);

    //Creating a list to store input data;
  }
}
