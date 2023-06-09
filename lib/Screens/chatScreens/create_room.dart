// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_declarations, use_build_context_synchronously
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables

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
import 'package:sessions/repositories/room_repository.dart';
import 'package:sessions/utils/classes.dart';
import 'package:sessions/utils/enums.dart';
import 'package:sessions/utils/navigations.dart';
import 'package:sessions/utils/util_methods.dart';

class CreateRoomControllers {
  final TextEditingController nameController = TextEditingController(),
      typeController = TextEditingController(),
      descController = TextEditingController();
}

class RoomInputVariables {
  String type;
  String coverPic;
  RoomInputVariables({
    this.type = "",
    this.coverPic = "",
  });
}

class CreateRoom extends StatefulWidget {
  const CreateRoom({super.key});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  List<RoomTypesEnum> enumList = [];
  List<String> typeDropDown = [];

  final RoomRepository roomRepository = RoomRepository();

  final CreateRoomControllers roomControllers = CreateRoomControllers();
  final RoomInputVariables inputVariables = RoomInputVariables();
  bool isLoading = false, isDisposed = false;

  @override
  void initState() {
    enumList = RoomTypesEnum.values;
    typeDropDown = List.generate(
        enumList.length, (index) => getRoomType(type: enumList[index]));
    typeDropDown.removeWhere(
      (element) => element == "userPublic",
    );
    super.initState();
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  void addCoverPhoto(String path) {
    setState(() {
      inputVariables.coverPic = path;
    });
  }

  Future<void> createRoomApi({required CreateRoomSend roomData}) async {
    try {
      if (isDisposed || !mounted) {
        return;
      }
      setState(() {
        isLoading = true;
      });
      await roomRepository.creatRoom(httpData: roomData);
      navigatorPop(context);
    } catch (error) {
      if (isDisposed || !mounted) {
        return;
      }
      setState(() {
        isLoading = false;
      });
      showMySnackBar(context, error.toString());
    }
  }

  void setDropDownValue({required String? value, required DropTypes dropType}) {
    if (value == null) {
      return;
    }

    inputVariables.type = value;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CurvedAppBar(
        title: "Create Room",
        leading: BackButtonNav(),
        actions: [],
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  LandScapePhotoTray(
                    addCoverPhoto: addCoverPhoto,
                    coverPhoto: inputVariables.coverPic,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7,
                    ),
                    child: Column(
                      children: [
                        SizedInputField(
                          fieldName: "Room title...",
                          controller: roomControllers.nameController,
                          icon: Icons.title,
                          maxLength: 50,
                        ),
                        SizedInputField(
                          fieldName: "Description...",
                          controller: roomControllers.descController,
                          icon: Icons.description,
                          extensible: true,
                        ),
                        CustomDropdownButton(
                          dropType: DropTypes.roomTypeDropDown,
                          prefixIcon: Icons.chat,
                          options: typeDropDown,
                          fieldName: "Select room type...",
                          changeValue: setDropDownValue,
                        ),
                        RoundedButton(
                          title: "Create Room",
                          onPress: () async {
                            String userIdUser;
                            String userName;
                            final profileState =
                                BlocProvider.of<ProfileBloc>(context).state;
                            if (profileState is ProfileCreatedState) {
                              userIdUser = profileState.profile.userId!;
                              userName = profileState.profile.userName!;
                            } else {
                              return;
                            }
                            if (roomControllers.nameController.text.isEmpty) {
                              showMySnackBar(
                                  context, "Room title cannot be empty!");
                              return;
                            }
                            if (roomControllers.descController.text.isEmpty) {
                              showMySnackBar(
                                  context, "Description cannot be empty!");
                              return;
                            }
                            if (inputVariables.type.isEmpty) {
                              showMySnackBar(
                                  context, "Room type cannot be empty!");
                              return;
                            }
                            CreateRoomSend roomSend = CreateRoomSend(
                              userName: userName,
                              createdBy: userIdUser,
                              description: roomControllers.descController.text,
                              name: roomControllers.nameController.text,
                              media: inputVariables.coverPic,
                              type: inputVariables.type,
                            );
                            await createRoomApi(roomData: roomSend);
                            BlocProvider.of<ProfileBloc>(context)
                                .add(LoadProfileEvent(userId: userIdUser));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              LoadingIndicator(
                circularBlue: true,
              ),
          ],
        ),
      ),
    );
  }
}
