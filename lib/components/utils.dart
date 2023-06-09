// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, sized_box_for_whitespace

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';
import 'package:sessions/assets.dart';
import 'package:sessions/constants.dart';
import 'package:sessions/utils/navigations.dart';

class HaveAccountOrNot extends StatelessWidget {
  const HaveAccountOrNot({
    super.key,
    required this.textValue,
    required this.linkName,
    required this.linkWidget,
  });

  final String textValue;
  final String linkName;
  final Widget linkWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          textValue,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: () {
            navigatorPop(context);
            navigatorPush(linkWidget, context);
          },
          child: Text(
            linkName,
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}

class SocialMediaIcon extends StatelessWidget {
  const SocialMediaIcon({
    super.key,
    required this.srcLink,
    required this.onPress,
  });

  final String srcLink;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kPrimaryLightColor,
          border: Border.all(
            width: 2,
            color: kPrimaryColor,
          ),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          srcLink,
          height: 15,
          width: 15,
        ),
      ),
    );
  }
}

class SocialMediaTray extends StatelessWidget {
  const SocialMediaTray({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialMediaIcon(
          srcLink: "assets/icons/facebook.svg",
          onPress: () {},
        ),
        SocialMediaIcon(
          srcLink: "assets/icons/google-plus.svg",
          onPress: () {},
        ),
        SocialMediaIcon(
          srcLink: "assets/icons/twitter.svg",
          onPress: () {},
        )
      ],
    );
  }
}

class NavHighlighter extends StatelessWidget {
  const NavHighlighter({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(
        bottom: 2,
      ),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.url,
  });

  final String title, subtitle, url;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: CircleAvatar(
          radius: 22.5,
          backgroundColor: Colors.white24,
          child: url != ""
              ? CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  width: 125,
                  height: 125,
                  errorWidget: (context, url, error) =>
                      Center(child: Icon(Icons.error)),
                )
              : Icon(
                  CupertinoIcons.person,
                  color: Colors.white,
                ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.white60,
        ),
      ),
    );
  }
}

Color getRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}

Color getRandomColorFromList() {
  List<Color> myColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black,
    Colors.pink,
    Colors.purple,
    Colors.brown,
    Colors.blueGrey,
    Colors.deepOrangeAccent,
    Colors.deepPurpleAccent,
    Colors.cyan,
  ];
  Random random = Random();
  int index = random.nextInt(myColors.length);
  return myColors[index];
}

Color getRandomRGB() {
  List<Color> myColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
  ];
  Random random = Random();
  int index = random.nextInt(myColors.length);
  return myColors[index];
}

Widget BackButtonNav() {
  return Builder(
    builder: (context) => Container(
      padding: EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          navigatorPop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
    ),
  );
}

class ClipTitle extends StatelessWidget {
  const ClipTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      width: size.width,
      child: Text(
        title,
        style: TextStyle(
          color: backgroundColor2.withOpacity(0.825),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class CircularProgressIndicatorOnStack extends StatelessWidget {
  const CircularProgressIndicatorOnStack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryColor.withOpacity(0.15),
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.width * 0.135,
          width: MediaQuery.of(context).size.width * 0.135,
          child: RiveAnimation.asset(
            Assets.assetsRiveAssetsLoadingcircular,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({
    super.key,
    this.circularBlue = false,
  });

  final bool circularBlue;

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: widget.circularBlue
            ? MediaQuery.of(context).size.height * 0.135
            : MediaQuery.of(context).size.width * 0.225,
        width: widget.circularBlue
            ? MediaQuery.of(context).size.width * 0.135
            : MediaQuery.of(context).size.width * 0.225,
        child: RiveAnimation.asset(
          widget.circularBlue
              ? Assets.assetsRiveAssetsLoadingcircular
              : Assets.assetsRiveAssetsLoading,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class DateTimeText extends StatelessWidget {
  const DateTimeText({
    super.key,
    required this.dateTime,
  });

  final String dateTime;

  @override
  Widget build(BuildContext context) {
    return Text(
      dateTime,
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }
}

class ExistingRoomTitle extends StatelessWidget {
  final String title;
  const ExistingRoomTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}

class ListTileTrailing extends StatelessWidget {
  final String title;
  final Color color;
  final Function? callBack;
  const ListTileTrailing(
      {super.key, required this.title, required this.color, this.callBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
