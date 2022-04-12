import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key, this.appBarTile, required this.url})
      : super(key: key);
  final String? appBarTile;
  final String url;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with WidgetsBindingObserver {
  late InAppWebViewController _webViewController;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _webViewController.android.resume();
    } else {
      _webViewController.android.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _webViewController.android.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
    return WillPopScope(
      onWillPop: () {
        _webViewController.android.pause();
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
                    // flutterWebViewPlugin.close();
                    // flutterWebViewPlugin.clearCache();
                    // flutterWebViewPlugin.cleanCookies();
                    _webViewController.android.pause();
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
        body: InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse(widget.url),
          ),
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT,
            );
          },
          initialOptions: InAppWebViewGroupOptions(
            android: AndroidInAppWebViewOptions(
              useHybridComposition: true,
            ),
            ios: IOSInAppWebViewOptions(
              allowsInlineMediaPlayback: true,
              limitsNavigationsToAppBoundDomains: true,
            ),
            crossPlatform: InAppWebViewOptions(
              javaScriptCanOpenWindowsAutomatically: true,
              userAgent:
                  'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Mobile Safari/537.36',
              disableContextMenu: true,
              useOnLoadResource: true,
              transparentBackground: true,
              minimumFontSize: 14,
              preferredContentMode: UserPreferredContentMode.MOBILE,
            ),
          ),
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
        ),
      ),
    );
  }
}
