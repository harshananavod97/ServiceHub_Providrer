import 'package:flutter/material.dart';
import 'package:servicehubprovider/utils/Colors.dart';
import 'package:servicehubprovider/api/api_controller.dart';
import 'package:servicehubprovider/screen/appoinments/appoinmentSecondTaskScreen.dart';
import 'package:servicehubprovider/styles.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppoinmentFirstTaskScreen extends StatefulWidget {
  AppoinmentFirstTaskScreen(
      {super.key, required this.index, required this.quiedapooinment});
  int index;
  bool quiedapooinment;

  @override
  State<AppoinmentFirstTaskScreen> createState() =>
      _AppoinmentFirstTaskScreenState();
}

class _AppoinmentFirstTaskScreenState extends State<AppoinmentFirstTaskScreen> {

  Apicontroller apicontroller = Apicontroller();
  final dateControlleer = TextEditingController();
  final timeControlleer = TextEditingController();
  final budgetControlleer = TextEditingController();


  AutovalidateMode switched = AutovalidateMode.disabled;


  final _timeformKey = GlobalKey<FormState>();
  final _dateformKey = GlobalKey<FormState>();
  final _budgetformKey = GlobalKey<FormState>();

  
  


  final dateFocusNode = FocusNode();
  final timeFocusNode = FocusNode();
  final budgetFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    dateControlleer.dispose();
    timeControlleer.dispose();
    budgetControlleer.dispose();
    dateFocusNode.dispose();
    timeFocusNode.dispose();
    budgetFocusNode.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        keyboardType: TextInputType.text,
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        String formattedDate = DateFormat('yyyy-MM-dd')
            .format(DateTime(picked.year, picked.month, picked.day));
        dateControlleer.text = formattedDate;
      }
    }

    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        String formattedTime =
            TimeOfDay(hour: picked.hour, minute: picked.minute)
                .format(context)
                .replaceAll(RegExp('[a-z]'), ''); // remove 'am' or 'pm'
        setState(() {
          timeControlleer.text = formattedTime;
        });
      }
    }

    return Scaffold(
      appBar: Styles.appBar(context),
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      body: Container(
        height: double.maxFinite,
        margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
        child: Stack(
          children: [
            ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Date',
                      style: labelText,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: AbsorbPointer(
                        child: Form(
                          autovalidateMode: switched,
                          key: _dateformKey,
                          child: TextFormField(
                            controller: dateControlleer,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: inputFieldBackgroundColor,
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 20,
                              color: lightText,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Date is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Time',
                      style: labelText,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _selectTime(context);
                      },
                      child: AbsorbPointer(
                        child: Form(
                          autovalidateMode: switched,
                          key: _timeformKey,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: timeControlleer,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: inputFieldBackgroundColor,
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.access_time),
                            ),
                            readOnly: true,
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 20,
                              color: lightText,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Time is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Estimated Budget',
                      style: labelText,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Form(
                      autovalidateMode: switched,
                      key: _budgetformKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Price is required';
                          }

                          if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) {
                            return 'Invalid price format';
                          }
                          if (value.length > 255) {
                            return 'Estimated Budget cannot exceed 255 characters';
                          }
                          return null;
                        },
                        controller: budgetControlleer,
                        keyboardType: TextInputType.number,
                        focusNode: budgetFocusNode,
                        style: const TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 20,
                            color: lightText),
                        decoration: formInputStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    switched = AutovalidateMode.always;
                  });

                  if (_budgetformKey.currentState!.validate() &&
                      _timeformKey.currentState!.validate() &&
                      _dateformKey.currentState!.validate()) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AppoinmentSecondTaskScreen(
                              quiedappoiment: widget.quiedapooinment,
                              index: widget.index,
                              budget: budgetControlleer.text,
                              date: dateControlleer.text,
                              time: timeControlleer.text,
                            )));
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: white),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: kPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7), // <-- Radius
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputField(String labelName, TextEditingController controller,
      TextInputType inputType, FocusNode focusNode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelName,
          style: labelText,
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
            controller: controller,
            keyboardType: inputType,
            focusNode: focusNode,
            style: const TextStyle(
                fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
            decoration: formInputStyle),
      ],
    );
  }
}
