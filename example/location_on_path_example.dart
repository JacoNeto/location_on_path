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

  // shows in the console if the currentLocation is on the Given math in at
  // least 20 meters
  print(isLocationOnPathWithRadius(ppoints, currentPosition, 20));
}
