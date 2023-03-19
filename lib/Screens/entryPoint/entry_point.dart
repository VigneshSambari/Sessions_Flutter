// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:sessions/components/navbar.dart';
import 'package:sessions/components/side_menu.dart';
import 'package:sessions/constants.dart';
import 'package:sessions/screens/blogScreens/blog_screen.dart';
import 'package:sessions/utils/rive_utils.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  late SMIBool sideBarClosed;
  bool isMenuClosed = true;

  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });

    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));

    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          color: backgroundColor2.withOpacity(0.8),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              left: isMenuClosed ? -275 : 0,
              width: 275,
              height: MediaQuery.of(context).size.height,
              child: SideMenu(),
            ),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(animation.value - 30 * pi * animation.value / 180),
              child: Transform.translate(
                offset: Offset(animation.value * 275, 0),
                child: Transform.scale(
                  scale: scaleAnimation.value,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(animation.value == 0 ? 0 : 25),
                    ),
                    child: BlogScreen(),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              left: isMenuClosed ? 0 : 217,
              curve: Curves.fastLinearToSlowEaseIn,
              child: MenuBurgerButton(
                riveInit: (artboard) {
                  StateMachineController controller =
                      RiveUtils.getRiveController(
                    artboard,
                    stateMachineName: "State Machine",
                  );
                  sideBarClosed = controller.findSMI("isOpen") as SMIBool;
                  sideBarClosed.value = true;
                },
                press: () {
                  sideBarClosed.value = !sideBarClosed.value;
                  if (isMenuClosed) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                  setState(() {
                    isMenuClosed = sideBarClosed.value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, animation.value * 100),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(animation.value == 0 ? 0 : 25),
          ),
          child: NavBarAnimated(),
        ),
      ),
    );
  }
}