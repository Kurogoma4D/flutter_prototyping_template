{{#includeTargetPlatformWorkaround}}
import 'dart:io';

import 'package:flutter/foundation.dart';
{{/includeTargetPlatformWorkaround}}
import 'package:flutter/material.dart';
{{#withDriverTest}}
import 'package:flutter_driver/driver_extension.dart';
{{/withDriverTest}}
{{#withPluginHook}}
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:{{pluginProjectName}}/{{pluginProjectName}}.dart';
{{/withPluginHook}}
{{#includeTargetPlatformWorkaround}}

// Sets a platform override for desktop to avoid exceptions. See
// https://flutter.dev/desktop#target-platform-override for more info.
void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}
{{/includeTargetPlatformWorkaround}}

{{^withDriverTest}}
{{^includeTargetPlatformWorkaround}}
void main() => runApp(MyApp());
{{/includeTargetPlatformWorkaround}}
{{#includeTargetPlatformWorkaround}}
void main() {
  _enablePlatformOverrideForDesktop();
  runApp(MyApp());
}
{{/includeTargetPlatformWorkaround}}
{{/withDriverTest}}
{{#withDriverTest}}
void main() {
{{#includeTargetPlatformWorkaround}}
  _enablePlatformOverrideForDesktop();
{{/includeTargetPlatformWorkaround}}
  // Enable integration testing with the Flutter Driver extension.
  // See https://flutter.dev/testing/ for more info.
  enableFlutterDriverExtension();
  runApp(MyApp());
}
{{/withDriverTest}}

{{^withPluginHook}}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YO')),
      body: Center(
        child: const Text("Hello World."),
      )
    );
  }
}

{{/withPluginHook}}
{{#withPluginHook}}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await {{pluginDartClass}}.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
{{/withPluginHook}}
