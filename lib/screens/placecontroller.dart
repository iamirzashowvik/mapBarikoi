import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';

class PlaceProvider extends ChangeNotifier {
  static PlaceProvider of(BuildContext context, {bool listen = true}) =>
      Provider.of<PlaceProvider>(context, listen: listen);

  bool isOnUpdateLocationCooldown = false;
  LocationAccuracy? desiredAccuracy;
  bool isAutoCompleteSearching = false;

  Future<Position?> updateCurrentLocation(
      bool forceAndroidLocationManager) async {
    try {
      LocationPermission value = await Geolocator.checkPermission();

      if (value == LocationPermission.whileInUse ||
          value == LocationPermission.always) {
        currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: desiredAccuracy ?? LocationAccuracy.high);
        return currentPosition;
      } else if (value == LocationPermission.denied ||
          value == LocationPermission.unableToDetermine) {
        LocationPermission value = await Geolocator.requestPermission();
        if (value == LocationPermission.whileInUse ||
            value == LocationPermission.always) {
          currentPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: desiredAccuracy ?? LocationAccuracy.high);
          return currentPosition;
        }
      } else {
        log(value.toString());
        return null;
      }
    } catch (e) {
      log(e.toString());
      currentPosition = null;
    }

    notifyListeners();
  }

  Position? _currentPoisition;
  Position? get currentPosition => _currentPoisition;
  set currentPosition(Position? newPosition) {
    _currentPoisition = newPosition;
    notifyListeners();
  }

  CameraPosition? _previousCameraPosition;
  CameraPosition? get prevCameraPosition => _previousCameraPosition;
  setPrevCameraPosition(CameraPosition prePosition) {
    _previousCameraPosition = prePosition;
  }

  CameraPosition? _currentCameraPosition;
  CameraPosition? get cameraPosition => _currentCameraPosition;
  setCameraPosition(CameraPosition? newPosition) {
    _currentCameraPosition = newPosition;
  }

  MaplibreMapController? _mapController;
  MaplibreMapController? get mapController => _mapController;
  set mapController(MaplibreMapController? controller) {
    _mapController = controller;
    notifyListeners();
  }
}
