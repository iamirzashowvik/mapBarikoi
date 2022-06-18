import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as RiverPOD;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:map/constants.dart';
import 'package:map/screens/placecontroller.dart';
import 'package:map/screens/riverpodbarikoi.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

class MyMap extends ConsumerWidget {
  final LatLng latLng;
  MyMap(this.latLng);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    changeLocation(PlaceProvider provider) async {
      num? lat = provider.mapController?.cameraPosition?.target.latitude;
      num? lon = provider.mapController?.cameraPosition?.target.longitude;
      log("lat: $lat, lon: $lon");
      ref.read(barikoiProvider).getLocation(lat, lon);
    }

    PlaceProvider provider = PlaceProvider.of(context, listen: false);
    String address = ref.watch(barikoiProvider).location;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps'),
      ),
      body: Stack(
        children: [
          MaplibreMap(
            styleString:
                "https://map.barikoi.com/styles/osm-liberty/style.json?key=$APIKEY",
            initialCameraPosition: CameraPosition(target: latLng, zoom: 12),
            myLocationRenderMode: MyLocationRenderMode.NORMAL,
            compassEnabled: true,
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
            onMapCreated: (MaplibreMapController controller) {
              provider.mapController = controller;
              provider.setCameraPosition(null);

              provider.updateCurrentLocation(false);
              // When select initialPosition set to true.

              provider
                  .setCameraPosition(CameraPosition(target: latLng, zoom: 12));
              changeLocation(provider);
            },
            trackCameraPosition: true,
            onCameraIdle: () {
              log("camera movement stopped");
              changeLocation(provider);
            },
            gestureRecognizers: Set()
              ..add(Factory<EagerGestureRecognizer>(
                  () => EagerGestureRecognizer())),
          ),
          pin(),
          Positioned(
            bottom: 10,
            child: Container(
              width: Get.width,
              child: Align(
                alignment: Alignment.center,
                child: RiverPOD.ProviderScope(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          color: Colors.white,
                          child: Text(address,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black))),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget pin() {
  return const Center(
    child: Icon(Icons.place, color: Colors.blue),
  );
}
