import 'dart:math';

import 'package:latlong2/latlong.dart';

// distance in meters from GLatLng point to GPolyline or GPolygon poly
bool isLocationOnPathWithRadius(
    List<LatLng> polyline, LatLng point, int radius) {
  int i;
  BdccGeo p = BdccGeo(point.latitude, point.longitude);

  for (i = 0; i < (polyline.length - 1); i++) {
    LatLng p1 = polyline[i];
    BdccGeo l1 = BdccGeo(p1.latitude, p1.longitude);

    LatLng p2 = polyline[i + 1];
    BdccGeo l2 = BdccGeo(p2.latitude, p2.longitude);

    double distance = p.functionDistanceToLineSegMtrs(l1, l2);

    if (distance < radius) return true;
  }
  return false;
}
// object

class BdccGeo {
  late double lat;
  late double lng;

  late double x;
  late double y;
  late double z;

  BdccGeo(this.lat, this.lng) {
    double theta = (lng * pi / 180.0);
    double rlat = functionBdccGeoGeocentricLatitude(lat * pi / 180.0);
    double c = cos(rlat);
    x = c * cos(theta);
    y = c * sin(theta);
    z = sin(rlat);
  }

  //returns in meters the minimum of the perpendicular distance of this point from the line segment geo1-geo2
  //and the distance from this point to the line segment ends in geo1 and geo2
  double functionDistanceToLineSegMtrs(BdccGeo geo1, BdccGeo geo2) {
    //point on unit sphere above origin and normal to plane of geo1,geo2
    //could be either side of the plane
    BdccGeo p2 = geo1.functioncrossNormalize(geo2);

    // intersection of GC normal to geo1/geo2 passing through p with GC geo1/geo2
    BdccGeo ip = functionBdccGeoGetIntersection(geo1, geo2, this, p2);

    //need to check that ip or its antipode is between p1 and p2
    double d = geo1.functiondistance(geo2);
    double d1p = geo1.functiondistance(ip);
    double d2p = geo2.functiondistance(ip);
    //window.status = d + ", " + d1p + ", " + d2p;
    if ((d >= d1p) && (d >= d2p)) {
      return functionBdccGeoRadiansToMeters(functiondistance(ip));
    } else {
      ip = ip.functionantipode();
      d1p = geo1.functiondistance(ip);
      d2p = geo2.functiondistance(ip);
    }
    if ((d >= d1p) && (d >= d2p)) {
      return functionBdccGeoRadiansToMeters(functiondistance(ip));
    } else {
      return functionBdccGeoRadiansToMeters(
          min(geo1.functiondistance(this), geo2.functiondistance(this)));
    }
  }

  // More Maths
  BdccGeo functioncrossNormalize(BdccGeo b) {
    double x = (this.y * b.z) - (this.z * b.y);
    double y = (this.z * b.x) - (this.x * b.z);
    double z = (this.x * b.y) - (this.y * b.x);
    double L = sqrt((x * x) + (y * y) + (z * z));
    BdccGeo r = BdccGeo(0, 0);
    r.x = x / L;
    r.y = y / L;
    r.z = z / L;

    return r;
  }

  // Returns the two antipodal points of intersection of two great
  // circles defined by the arcs geo1 to geo2 and
  // geo3 to geo4. Returns a point as a Geo, use .antipode to get the other point
  BdccGeo functionBdccGeoGetIntersection(
      BdccGeo geo1, BdccGeo geo2, BdccGeo geo3, BdccGeo geo4) {
    BdccGeo geoCross1 = geo1.functioncrossNormalize(geo2);
    BdccGeo geoCross2 = geo3.functioncrossNormalize(geo4);
    return geoCross1.functioncrossNormalize(geoCross2);
  }

  double functiondistance(BdccGeo v2) {
    return atan2(v2.functioncrossLength(this), v2.functiondot(this));
  }

  //More Maths
  double functioncrossLength(BdccGeo b) {
    double x = (this.y * b.z) - (this.z * b.y);
    double y = (this.z * b.x) - (this.x * b.z);
    double z = (this.x * b.y) - (this.y * b.x);
    return sqrt((x * x) + (y * y) + (z * z));
  }

  //Maths
  double functiondot(BdccGeo b) {
    return ((x * b.x) + (y * b.y) + (z * b.z));
  }

  //from Radians to Meters
  double functionBdccGeoRadiansToMeters(double rad) {
    return rad * 6378137.0; // WGS84 Equatorial Radius in Meters
  }

  // point on opposite side of the world to this point
  BdccGeo functionantipode() {
    return functionscale(-1.0);
  }

  //More Maths
  BdccGeo functionscale(double s) {
    BdccGeo r = BdccGeo(0, 0);
    r.x = x * s;
    r.y = y * s;
    r.z = z * s;
    return r;
  }

  // Convert from geographic to geocentric latitude (radians).
  double functionBdccGeoGeocentricLatitude(double geographicLatitude) {
    double flattening = 1.0 / 298.257223563; //WGS84
    double f = (1.0 - flattening) * (1.0 - flattening);
    return atan((tan(geographicLatitude) * f));
  }
}
