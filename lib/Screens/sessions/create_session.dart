// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_init_to_null, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sessions/bloc/profile/profile_bloc.dart';
import 'package:sessions/components/appbar.dart';
import 'package:sessions/components/buttons.dart';
import 'package:sessions/components/drop_downs.dart';
import 'package:sessions/components/input_fields.dart';
import 'package:sessions/components/snackbar.dart';
import 'package:sessions/components/trays.dart';
import 'package:sessions/components/utils.dart';
import 'package:sessions/constants.dart';
import 'package:sessions/models/room.model.dart';
import 'package:sessions/repositories/room_repository.dart';
import 'package:sessions/repositories/session_repository.dart';
import 'package:sessions/utils/classes.dart';
import 'package:sessions/utils/enums.dart';
import 'package:sessions/utils/navigations.dart';
import 'package:sessions/utils/util_methods.dart';

class CreateSession extends StatefulWidget {
  const CreateSession({super.key});

  @override
  State<CreateSession> createState() => _CreateSessionState();
}

class SessionInputController {
  TextEditingController titleController = TextEditingController(),
      descController = TextEditingController(),
      amountController = TextEditingController(),
      startDateController = TextEditingController(),
      endDateController = TextEditingController(),
      startTimeController = TextEditingController(),
      endTimeController = TextEditingController(),
      fieldController = TextEditingController();
}

class SessionInputVar {
  String type = "", repeat = "", coverPic = "", field = "";
  DateTime? startDate, endDate, startTime, endTime;
}

class _CreateSessionState extends State<CreateSession> {
  SessionRepository sessionRepository = SessionRepository();
  RoomRepository roomRepository = RoomRepository();
  SessionInputVar inputVariables = SessionInputVar();
  SessionInputController sessionController = SessionInputController();

  bool isLoading = false;
  List<String> typeDropDown = [
    "Electronics",
    "Computer Science",
    "Mechanical",
    "UPSC",
    "Civil",
    "Production",
    "Medical",
    "Other"
  ];

  @override
  void initState() {
    super.initState();
    sessionController.startDateController.text =
        formatDate(date: DateTime.now());
    sessionController.startTimeController.text =
        formatTime(time: DateTime.now());
    DateTime now = DateTime.now();
    DateTime dateOnly = DateTime(now.year, now.month, now.day);
    inputVariables.startDate = dateOnly;
    inputVariables.startTime = now;
  }

  void setTime({required DateTime time, required bool startEnd}) {
    if (!startEnd) {
      inputVariables.startTime = time;
      sessionController.startTimeController.text = formatTime(time: time);
      setState(() {
        sessionController.startTimeController;
      });
    } else {
      inputVariables.endTime = time;
      sessionController.endTimeController.text = formatTime(time: time);
      setState(() {
        sessionController.endTimeController;
      });
    }
  }

  void setDate({required DateTime date, required bool startEnd}) {
    if (!startEnd) {
      inputVariables.startDate = date;
      sessionController.startDateController.text = formatDate(date: date);
      setState(() {
        sessionController.startDateController;
      });
    } else {
      inputVariables.endDate = date;
      sessionController.endDateController.text = formatDate(date: date);
      setState(() {
        sessionController.endDateController;
      });
    }
  }

  void setDropDownValue({required String? value, required DropTypes dropType}) {
    if (value == null) {
      return;
    }

    inputVariables.field = value;
  }

  void addCoverPhoto(String path) {
    setState(() {
      inputVariables.coverPic = path;
    });
  }

  void dropDownField({required String? value, required DropTypes dropType}) {
    if (value == null) {
      return;
    }
    inputVariables.field = value;
  }

  void dropDownType({required String? value, required DropTypes dropType}) {
    if (value == null) {
      return;
    }
    inputVariables.type = value;
  }

  void dropDownRepeat({required String? value, required DropTypes dropType}) {
    if (value == null) {
      return;
    }
    inputVariables.repeat = value;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CurvedAppBar(
        title: "Create Session",
        actions: [],
        leading: BackButtonNav(),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.all(5),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  LandScapePhotoTray(
                    addCoverPhoto: addCoverPhoto,
                    coverPhoto: inputVariables.coverPic,
                  ),
                  EntryField(
                    hintText: "Enter your title",
                    title: "Title",
                    maxLines: 1,
                    maxLength: 50,
                    controller: sessionController.titleController,
                  ),
                  EntryField(
                    hintText: "Description of the session",
                    title: "Description",
                    maxLines: 10,
                    controller: sessionController.descController,
                  ),
                  DropDownWithTitle(
                    typeDropDown: typeDropDown,
                    setDropDownValue: dropDownField,
                    title: "Select session field",
                    dropDowntitle: "Electronics, mechanical...",
                  ),
                  inputVariables.field == "Other"
                      ? EntryField(
                          hintText: "Enter the field",
                          title: "Field",
                          maxLines: 1,
                          maxLength: null,
                        )
                      : SizedBox(),
                  DropDownWithTitle(
                    typeDropDown: ["privateSession", "publicSession"],
                    setDropDownValue: dropDownType,
                    title: "Select session type",
                    dropDowntitle: "Private, public...",
                  ),
                  EntryField(
                    hintText: "Pay amount in rupees...",
                    title: "Pay amount",
                    inputType: TextInputType.number,
                    controller: sessionController.amountController,
                  ),
                  EntryField(
                    hintText: "Start date",
                    title: "Start date",
                    suffix: MyDatePicker(setvalue: setDate, startEnd: false),
                    enabled: false,
                    controller: sessionController.startDateController,
                  ),
                  EntryField(
                    hintText: "End date",
                    title: "End date",
                    suffix: MyDatePicker(setvalue: setDate, startEnd: true),
                    enabled: false,
                    controller: sessionController.endDateController,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: EntryField(
                          hintText: "Start time",
                          title: "Start time",
                          suffix: TimePickerWidget(
                              setvalue: setTime, startEnd: false),
                          enabled: false,
                          controller: sessionController.startTimeController,
                        ),
                      ),
                      Expanded(
                        child: EntryField(
                          hintText: "End time",
                          title: "End time",
                          suffix: TimePickerWidget(
                              setvalue: setTime, startEnd: true),
                          enabled: false,
                          controller: sessionController.endTimeController,
                        ),
                      ),
                    ],
                  ),
                  DropDownWithTitle(
                    typeDropDown: ["Daily", "Weekly", "Monthly", "No repeat"],
                    setDropDownValue: dropDownRepeat,
                    title: "Repeat",
                    dropDowntitle: "Daily, Weekly...",
                  ),
                  RoundedButton(
                    title: "Create",
                    onPress: () async {
                      try {
                        if (sessionController.titleController.text.isEmpty ||
                            sessionController.descController.text.isEmpty ||
                            sessionController.amountController.text.isEmpty ||
                            inputVariables.endDate == null ||
                            inputVariables.startDate == null ||
                            inputVariables.endTime == null ||
                            inputVariables.startTime == null ||
                            inputVariables.field.isEmpty ||
                            inputVariables.type.isEmpty ||
                            inputVariables.repeat.isEmpty) {
                          showMySnackBar(context, "Fill all the field!");
                          return;
                        }
                        int diff = inputVariables.endDate!
                            .difference(inputVariables.startDate!)
                            .inDays;

                        if (diff < 0) {
                          showMySnackBar(
                              context, "End date cannot be behind start date");
                          return;
                        }

                        if (inputVariables.startDate ==
                            inputVariables.endDate) {
                          DateTime date1 = inputVariables
                              .startTime!; // get the first date with time set to 10:30 AM
                          DateTime date2 = inputVariables
                              .endTime!; // get the second date with time set to 2:45 PM

                          DateTime time1 = DateTime(
                              0, 0, 0, date1.hour, date1.minute, date1.second);
                          DateTime time2 = DateTime(
                              0, 0, 0, date2.hour, date2.minute, date2.second);

                          int difference =
                              time1.compareTo(time2); // compare the two times

                          if (difference > 0) {
                            showMySnackBar(context,
                                "End time should be greater than start time!");
                            return;
                          }
                        }

                        setState(() {
                          isLoading = true;
                        });
                        String userId = "";
                        String userName = "";
                        ProfileState profileState =
                            BlocProvider.of<ProfileBloc>(context).state;
                        if (profileState is ProfileCreatedState) {
                          userId = profileState.profile.userId!;
                          userName = profileState.profile.userName!;
                          RoomModel room = await roomRepository.creatRoom(
                            httpData: CreateRoomSend(
                              userName: userName,
                              name: sessionController.titleController.text,
                              description:
                                  sessionController.descController.text,
                              createdBy: userId,
                              type: inputVariables.type,
                              media: inputVariables.coverPic,
                            ),
                          );

                          await sessionRepository.createSession(
                            httpData: CreateSessionSend(
                              field: inputVariables.field,
                              startDate: inputVariables.startDate!,
                              endDate: inputVariables.endDate!,
                              payAmount: int.parse(
                                  sessionController.amountController.text),
                              roomId: room.roomId!,
                              createdBy: userId,
                              startTime: inputVariables.startTime!,
                              endTime: inputVariables.endTime!,
                              repeat: inputVariables.repeat,
                            ),
                          );
                          setState(() {
                            isLoading = false;
                          });
                          BlocProvider.of<ProfileBloc>(context).add(
                              LoadProfileEvent(
                                  userId: profileState.profile.userId!));
                        }

                        navigatorPop(context);
                      } catch (error) {
                        setState(() {
                          isLoading = false;
                        });
                        showMySnackBar(
                          context,
                          error.toString(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            if (isLoading) CircularProgressIndicatorOnStack()
          ],
        ),
      ),
    );
  }
}

class DropDownWithTitle extends StatelessWidget {
  final List<String> typeDropDown;
  final Function setDropDownValue;
  final String title, dropDowntitle;
  const DropDownWithTitle({
    super.key,
    required this.typeDropDown,
    required this.setDropDownValue,
    required this.title,
    required this.dropDowntitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: kPrimaryDarkColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          CustomDropdownButton(
            dropType: DropTypes.roomTypeDropDown,
            prefixIcon: Icons.chat,
            options: typeDropDown,
            fieldName: dropDowntitle,
            changeValue: setDropDownValue,
            sharpCorner: true,
          ),
        ],
      ),
    );
  }
}

class MyDatePicker extends StatefulWidget with WidgetsBindingObserver {
  final bool startEnd;
  final Function({required DateTime date, required bool startEnd}) setvalue;

  const MyDatePicker(
      {super.key, required this.startEnd, required this.setvalue});
  @override
  MyDatePickerState createState() => MyDatePickerState();
}

class MyDatePickerState extends State<MyDatePicker> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.setvalue(date: picked, startEnd: widget.startEnd);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.calendar_today,
        color: kPrimaryColor,
      ),
      onPressed: () => _selectDate(context),
    );
  }
}

class TimePickerWidget extends StatefulWidget {
  final bool startEnd;
  final Function({required DateTime time, required bool startEnd}) setvalue;

  const TimePickerWidget(
      {super.key, required this.setvalue, required this.startEnd});
  @override
  TimePickerWidgetState createState() => TimePickerWidgetState();
}

class TimePickerWidgetState extends State<TimePickerWidget> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();

    _selectedTime = TimeOfDay.now();

    // widget.setvalue(time: dateTime, startEnd: widget.startEnd);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.access_time,
        color: kPrimaryColor,
      ),
      onPressed: () async {
        final TimeOfDay? newTime = await showTimePicker(
          context: context,
          initialTime: _selectedTime,
        );
        if (newTime != null) {
          setState(() {
            _selectedTime = newTime;
            DateTime dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                newTime.hourOfPeriod +
                    (_selectedTime.period == DayPeriod.pm ? 12 : 0),
                newTime.minute);
            widget.setvalue(time: dateTime, startEnd: widget.startEnd);
          });
        }
      },
    );
  }
}
