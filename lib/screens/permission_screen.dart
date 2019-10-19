import 'package:clima/screens/loading_screen.dart';
import 'package:clima/screens/location_screen.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

const locationPermission = 'Location Permission';
const okButtonLabel = 'OK';
const cancelButtonLabel = 'CANCEL';
const alertContent = 'Please allow location permission.';
const defaultCity = 'Melbourne';

class PermissionScreen extends StatefulWidget {
  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool accessGranted = false;
  bool gpsOn;
  Location location = Location();
  GeolocationStatus geolocationStatus;
  String alertMessage = alertContent;

  @override
  void initState() {
    super.initState();
    !accessGranted ? getLocation() : getStatus();
  }

  void getLocation() async {
    getStatus();
    print('Getting location');

    await location.getCurrentLocation();
    print('Got location');

    getStatus();
  }

  void getStatus() async {
    geolocationStatus = await location.getStatus();
    print(geolocationStatus);
    if (geolocationStatus == GeolocationStatus.granted &&
        await location.isLocationServiceEnabled()) {
      setState(() {
        accessGranted = true;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoadingScreen(),
          ),
        );
      });
    } else if (await location.isLocationServiceEnabled() && accessGranted) {
      setState(() {
        alertMessage = 'Please enable GPS';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building permission Screen');
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Center(
        child: AlertDialog(
          title: Text(locationPermission),
          content: Text(alertContent),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                getLocation(); // Ask for permission
                getStatus(); // once got permission move to LoadingScreen.
              },
              child: Text(okButtonLabel),
            ),
            /**
             * If user press Cancel button then go to LocationScreen.
             */
            FlatButton(
              onPressed: () async {
                WeatherModel weatherModel = WeatherModel();
                dynamic defaultData =
                    await weatherModel.getCityWeather(defaultCity);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationScreen(
                      locationWeather: defaultData,
                    ),
                  ),
                );
              },
              child: Text(cancelButtonLabel),
            )
          ],
        ),
      ),
    );
  }
}
