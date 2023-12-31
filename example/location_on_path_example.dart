import 'package:location_on_path/location_on_path.dart';

void main() {
  // polyline points
  List<LatLng> ppoints = [
    LatLng(13.388860, 52.517037),
    LatLng(13.397634, 52.529407),
    LatLng(13.428555, 52.523219)
  ];
  // currentPosition
  LatLng currentPosition = LatLng(-5.20640492919849, -37.324122839780465);
  //
  bool isLocationOnPath =
      isLocationOnPathWithRadius(ppoints, currentPosition, 20);

  // shows in the console if the currentLocation is on the Given path in at
  // least 20 meters
  print(isLocationOnPath);

  if (isLocationOnPathWithRadius(ppoints, currentPosition, 20)) {
    //TODO continue
  } else {
    //TODO recalculates the route
  }
}
