import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:servicehubprovider/screen/main_screen.dart';
import 'package:servicehubprovider/utils/Navigation_Function.dart';
import 'package:servicehubprovider/utils/constant.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageController extends GetxController {
  PickedFile? _pickedFile;
  PickedFile? get pickedFile => _pickedFile;
  String? _imagepath;
  String? get imagePath => _imagepath;

  final _picker = ImagePicker();

  // Implementing the image picker
  Future<void> pickImage(String providerid, BuildContext context) async {
    _pickedFile = await _picker.getImage(source: ImageSource.gallery);
    // update();
    print("provider id is : " + providerid);
    upload(providerid.toString(), context);
  }

  Future<bool> upload(String providerid, BuildContext context) async {
    update();
    bool sucess = false;
    http.StreamedResponse response =
        await UpdateProfile(providerid, _pickedFile, context);
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["mesage"].toString();

      sucess = true;
      _imagepath = message;
      Logger().i(message);
    } else {
      print("error uploading image");
    }
    update();
    return sucess;
  }

  Future<http.StreamedResponse> UpdateProfile(
      String id, PickedFile? data, BuildContext context) async {
    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.parse(constant.APPEND_URL + 'provider-profile-picture'),
    );
    if (GetPlatform.isMobile && data != null) {
      File _file = File(data.path);
      request.fields['id'] = id;
      request.files.add(http.MultipartFile(
        'profile_pic',
        _file.readAsBytes().asStream(),
        _file.lengthSync(),
        filename: _file.path.split('/').last,
      ));
    }

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Logger().i("sucess uploading");

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text(" Upload Successful ")),
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
    } else {
      Logger().e("upload unsucessfull");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text(" Upload Unsuccessful ")),
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
    }
    return response;
  }
}
