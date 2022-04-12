import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'custom_webview.dart';

class HeavyGamePage extends StatefulWidget {
  const HeavyGamePage({Key? key, this.appBarTile, required this.url})
      : super(key: key);
  final String? appBarTile;
  final String url;

  @override
  State<HeavyGamePage> createState() => _HeavyGamePageState();
}

class _HeavyGamePageState extends State<HeavyGamePage>
    with WidgetsBindingObserver {
  final webviewReference = FlutterWebviewPlugin();
  Rect? _rect;
  Timer? _resizeTimer;
  StreamSubscription? _onBack;
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
    webviewReference.close();

    _onBack = webviewReference.onBack.listen((_) async {
      if (!mounted) {
        return;
      }

      // The willPop/pop pair here is equivalent to Navigator.maybePop(),
      // which is what's called from the flutter back button handler.
      final pop = await _topMostRoute.willPop();
      if (pop == RoutePopDisposition.pop) {
        // Close the webview if it's on the route at the top of the stack.
        final isOnTopMostRoute = _topMostRoute == ModalRoute.of(context);
        if (isOnTopMostRoute) {
          webviewReference.close();
        }
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
    webviewReference.reloadUrl("");
    _onBack?.cancel();
    _resizeTimer?.cancel();
    webviewReference.close();
    webviewReference.dispose();
  }

  Route<dynamic> get _topMostRoute {
    Route? topMost;
    Navigator.popUntil(context, (route) {
      topMost = route;
      return true;
    });
    return topMost!;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();

        return Future.value(false);
      },
      child: Scaffold(
        appBar: widget.appBarTile != null
            ? AppBar(
                backgroundColor: Colors.black,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                  widget.appBarTile!,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            : null,
        body: WebviewPlaceholder(
          onRectChanged: (Rect value) {
            if (_rect == null) {
              _rect = value;
              webviewReference.launch(
                widget.url,
                rect: _rect,
              );
            } else {
              if (_rect != value) {
                _rect = value;
                _resizeTimer?.cancel();
                _resizeTimer = Timer(const Duration(milliseconds: 250), () {
                  // avoid resizing to fast when build is called multiple time
                  webviewReference.resize(_rect!);
                });
              }
            }
          },
          child: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
