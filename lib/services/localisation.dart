import 'package:geolocator/geolocator.dart';

class Localisation {
  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Accee Refuse');
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<double?> getLongitude() async {
    final position = await getCurrentLocation();
    return position.longitude;
  }

  Future<double?> getLatitude() async {
    final position = await getCurrentLocation();
    return position.latitude;
  }

  Future<Position?> getPosition() async {
    final position = await getCurrentLocation();
    return position;
  }
}
