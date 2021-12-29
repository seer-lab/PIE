import 'package:flutter/material.dart';
import 'package:dp_lifecycle/ui/root_page.dart';
import 'package:get/route_manager.dart';
import 'package:dp_lifecycle/controllers/lifecycle_bindings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Design Pattern Lifecycle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialBinding: LifecycleBindings(),
      home: RootPage(),
    );
  }
}
