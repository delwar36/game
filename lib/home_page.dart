import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Games",
          style: TextStyle(
            color: const Color(0xff5584AC),
            fontSize: 26.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed("game2");
            },
            child: buildButton("Fish Adventure"),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed("game3");
            },
            child: buildButton("Tic Tac Toe"),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed("game1");
            },
            child: buildButton("Amazing Basketball"),
          ),
        ],
      ),
    );
  }
}

Container buildButton(String text) {
  return Container(
    height: 60.h,
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
    decoration: BoxDecoration(
      color: const Color(0xff5584AC),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18.sp,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}
