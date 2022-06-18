import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:get/get.dart';
import 'package:map/screens/maps.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({Key? key}) : super(key: key);

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  loc.Location locationX = loc.Location();
  Future checkGps() async {
    if (!await locationX.serviceEnabled()) {
      await locationX.requestService();

      if (await locationX.serviceEnabled()) {
        Get.snackbar('Please wait', 'We are fetching your location',
            backgroundColor: Colors.white);
        return true;
      }
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    checkGpss();
  }

  checkGpss() async {
    bool isGpsOn = await checkGps() ?? false;

    if (isGpsOn) {
      var lat = await locationX.getLocation();
//23.820328, 90.443541
      Get.to(
          MyMap(LatLng(lat.latitude ?? 23.820328, lat.longitude ?? 90.443541)));
    } else {
      Get.snackbar('Turn on GPS', 'and try again.',
          backgroundColor: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text('GetLocation'),
        ]),
      ),
    );
  }
}
