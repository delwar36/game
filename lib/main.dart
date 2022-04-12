import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game/game_page.dart';
import 'package:game/home_page.dart';

import 'package:permission_handler/permission_handler.dart';

import 'heavy_game.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.camera.request();
  await Permission.microphone.request();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          return null;
        },
      );
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
    ));

    return ScreenUtilInit(
        designSize: const Size(414, 837),
        minTextAdapt: true,
        splitScreenMode: false,
        builder: () {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Game',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            builder: (context, child) {
              ScreenUtil.setContext(context);
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              );
            },
            home: const HomePage(),
            routes: {
              "game1": (_) => const HeavyGamePage(
                    url: "http://amazingbasketball.befriendme.me/",
                    appBarTile: "Amazing Basketball",
                  ),
              "game2": (_) => const HeavyGamePage(
                  url: "http://fishadventure.befriendme.me/",
                  appBarTile: "Fish Adventure"),
              "game3": (_) => const NewWidget(),
            },
          );
        });
  }
}

class NewWidget extends StatefulWidget {
  const NewWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<NewWidget> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            height: double.infinity,
            width: 50,
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    "Tic Tac Toe",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const RotatedBox(
                    quarterTurns: 3,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const Expanded(child: NewWidget2()),
        ],
      ),
    );
  }
}

class NewWidget2 extends StatelessWidget {
  const NewWidget2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    return const GamePage(
      url: "https://tictactoe3dlive.befriendme.me/",
      //appBar: customAppBar("Tic Tac Toe"),
    );
  }
}
