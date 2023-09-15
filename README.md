<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Dart implementation of the bdcc GeoDistanceAlgorithm. The algorithm calculates if a single coordinate is near a polyline path in a given radius. This can be used to detect when it is a good moment to recalculate a route in navigation.

## Features

This package has the following method:
* ```isLocationOnPathWithRadius(List<LatLng> polyline, LatLng point, int radius)``` returns ```true``` if the distance from ```point``` to ```polyline``` is at least ```radius``` meters, and ```false``` if it is not.

## Usage

```dart
if (isLocationOnPathWithRadius(ppoints, currentPosition, 20)) {
    // continue
} else {
    // recalculates the route
}
```