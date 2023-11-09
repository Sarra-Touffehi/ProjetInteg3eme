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

  Future<bool> localisationsProche(Localisation loc) async {
    final currentPosition = await getPosition();
    final locPosition = await loc.getPosition();

    if (currentPosition != null && locPosition != null) {
      double distance = await calculateDistance(currentPosition, locPosition);
      if (distance < 5000) {
        return true;
      } else {
        return false;
      }
    } else {
      throw 'One or both positions are null';
    }
  }

  Future<bool> positionsProche(Position position1,Position position2) async {

    if (position1 != null && position2 != null) {
      double distance = await calculateDistance(position1, position2);
      if (distance < 5000) {
        return true;
      } else {
        return false;
      }
    } else {
      throw 'One or both positions are null';
    }
  }


  Future<double> calculateDistance(Position location1, Position location2) async {
    double distance = Geolocator.distanceBetween(
      location1.latitude, location1.longitude,
      location2.latitude, location2.longitude,
    );
    return distance;
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
