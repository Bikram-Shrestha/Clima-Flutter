import 'package:geolocator/geolocator.dart';

class Location {
  double latitude;
  double longitude;
  dynamic status;

  Future<GeolocationStatus> getStatus() async {
    try {
      GeolocationStatus geolocationStatus =
          await Geolocator().checkGeolocationPermissionStatus();
      return geolocationStatus;
    } catch (e) {
      print(e);
      return GeolocationStatus.unknown;
    }
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator().isLocationServiceEnabled();
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude;
      longitude = position.longitude;
      print('Getting location');
    } on Exception catch (e) {
      print(e);
    }
  }
}
