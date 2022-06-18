import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:map/screens/getuserlocation.dart';
import 'package:map/screens/maps.dart';
import 'package:map/screens/placecontroller.dart';
import 'package:provider/provider.dart' as Provider;

void main() {
  runApp(ProviderScope(
      child: Provider.MultiProvider(
          providers: [
        Provider.ChangeNotifierProvider(create: (_) => PlaceProvider()),
      ],
          child: GetMaterialApp(
            home: const MyApp(),
          ))));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GetLocation(),
    );
  }
}
