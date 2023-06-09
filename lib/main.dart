// ignore_for_file: prefer_const_constructors, unused_import, unnecessary_import, prefer_const_literals_to_create_immutables, prefer_final_fields, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'dart:math';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sessions/bloc/session/session_bloc.dart';
import 'package:sessions/callback.dart';
import 'package:sessions/models/session.model.dart';
import 'package:sessions/notifications/onesignal/push_notifications.dart';
import 'package:sessions/repositories/session_repository.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:sessions/bloc/profile/profile_bloc.dart';
import 'package:sessions/constants.dart';
import 'package:sessions/repositories/blog_repository.dart';
import 'package:sessions/repositories/message_repository.dart';
import 'package:sessions/repositories/profile_repository.dart';
import 'package:sessions/repositories/room_repository.dart';
import 'package:sessions/repositories/user_repository.dart';
import 'package:sessions/screens/blogScreens/blog_screen.dart';
import 'package:sessions/screens/blogScreens/createblog_screen.dart';
import 'package:sessions/screens/chatScreens/chat_entry.dart';
import 'package:sessions/screens/chatScreens/chat_screen.dart';
import 'package:sessions/screens/chatScreens/chats_display.dart';
import 'package:sessions/screens/entryPoint/entry_point.dart';
import 'package:sessions/screens/home/home_screen.dart';
import 'package:sessions/screens/login/login_screen.dart';
import 'package:sessions/screens/profile/bottom_sheet.dart';
import 'package:sessions/screens/profile/components/profile_details.dart';
import 'package:sessions/screens/profile/create_profile.dart';
import 'package:sessions/screens/profile/view_profile.dart';
import 'package:sessions/screens/signup/signup_screen.dart';
import 'package:sessions/screens/welcome/welcome_screen.dart';
import 'package:sessions/socket/socket_client.dart';
import 'package:sessions/utils/classes.dart';
import 'package:sessions/utils/navigations.dart';
import 'package:video_player/video_player.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'bloc/message/message_bloc.dart';
import 'bloc/room/room_bloc.dart';
import 'bloc/user/user_bloc.dart';

void main() async {
  //Dotenv initialization asynchronous
  await dotenv.load();

  //Native calling
  WidgetsFlutterBinding.ensureInitialized();

  //Hydrated bloc storage initialization
  final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  HydratedBloc.storage = storage;

  //Orientation setup
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //zego cloud
  final navigatorKey = GlobalKey<NavigatorState>();
  ZegoUIKit().initLog().then((value) {
    runApp(MyApp(
      navigatorKey: navigatorKey,
    ));
  });
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key, required this.navigatorKey});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Widget currentScreen = WelcomeScreen();

  Future<void> oneSignalInit(BuildContext context) async {
    //Remove this method to stop OneSignal Debugging
    //OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId(oneSignalAppId!);

    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});
// Set notification opened handler
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {});

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // Will be called whenever the subscription changes
      // (ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // Will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
  }

  @override
  void initState() {
    super.initState();
    oneSignalInit(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: kPrimaryLightColor,
        statusBarColor: Colors.transparent,
      ),
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: kPrimaryColor,
    ));
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider(
          create: (context) => ProfileRepository(),
        ),
        RepositoryProvider(
          create: (context) => RoomRepository(),
        ),
        RepositoryProvider(
          create: (context) => SessionRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserBloc(
              RepositoryProvider.of<UserRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(
              RepositoryProvider.of<ProfileRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => RoomBloc(
              RepositoryProvider.of<RoomRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => RoomBloc(
              RepositoryProvider.of<RoomRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => SessionBloc(
              RepositoryProvider.of<SessionRepository>(context),
            ),
          ),
        ],
        child: MaterialApp(
          navigatorKey: widget.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'CommunityApp',
          theme: ThemeData(
            fontFamily: "Intel",
            primarySwatch: kPrimarySwatch,
            scaffoldBackgroundColor: Colors.white,
          ),

          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            MonthYearPickerLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', 'US'),
          ],
          builder: (BuildContext context, Widget? child) {
            return Stack(
              children: [
                child!,

                /// support minimizing
                ZegoUIKitPrebuiltCallMiniOverlayPage(
                  contextQuery: () {
                    return widget.navigatorKey.currentState!.context;
                  },
                ),
              ],
            );
          },
          // home: Scaffold(
          //   body: Container(
          //     child: VideoPlayerWidget(
          //       url: urls[0],
          //     ),
          //   ),
          // ),
          home: Builder(builder: (BuildContext context) {
            ProfileState profileState =
                BlocProvider.of<ProfileBloc>(context).state;
            UserState userState = BlocProvider.of<UserBloc>(context).state;
            if (profileState is ProfileCreatedState) {
              //set one signal userId
              OneSignal.shared.setExternalUserId(profileState.profile.userId!);
              currentScreen = EntryPoint();
            } else if (userState is UserSignedInState) {
              currentScreen = CreateProfile();
            } else if (userState is UserSignedUpState) {
              currentScreen = Loginscreen();
            }

            return currentScreen;
          }),
        ),
      ),
    );
  }
}

List<String> urls = [
  "https://res.cloudinary.com/drx5qtqvh/video/upload/v1682424320/communityapplication/kyut26dq2ivpaqtiywnn.mp4",
  "https://res.cloudinary.com/drx5qtqvh/video/upload/v1682424320/communityapplication/kyut26dq2ivpaqtiywnn.mp4",
];

class ScreenChanger extends StatefulWidget {
  const ScreenChanger({super.key});

  @override
  State<ScreenChanger> createState() => _ScreenChangerState();
}

class _ScreenChangerState extends State<ScreenChanger> {
  Widget currenScreen = EntryPoint();
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserInitialState) {
              currenScreen = WelcomeScreen();
              setState(() {
                currenScreen;
              });
            }
            if (state is UserSignedInState) {
              currenScreen = CreateProfile();
              setState(() {});
            }
          },
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {},
        ),
      ],
      child: currenScreen,
    );
  }
}
