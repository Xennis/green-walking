import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart' show LatLng;

class LocationButton extends StatefulWidget {
  const LocationButton(
      {super.key,
      required this.onOkay,
      required this.onNoPermissions,
      required this.userLocation});

  final VoidCallback onOkay;
  final VoidCallback onNoPermissions;
  final ValueNotifier<LatLng?> userLocation;

  @override
  _LocationButtonState createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  late final Timer _timer;

  bool _locationServiceEnabled = true;
  bool _locationCentered = false;

  @override
  void initState() {
    super.initState();

    _checkLocationServiceEnabled();
    _timer = Timer.periodic(const Duration(seconds: 1, microseconds: 500),
        (Timer result) {
      _checkLocationServiceEnabled();
    });

    widget.userLocation.addListener(_checkUserLocationCentered);
  }

  @override
  void dispose() {
    _timer.cancel();
    widget.userLocation.removeListener(_checkUserLocationCentered);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final IconData icon = _locationServiceEnabled
        ? _locationCentered
            ? Icons.my_location
            : Icons.location_searching
        : Icons.location_disabled;
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          onPressed: _onPressed,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _checkUserLocationCentered() {
    if (_locationCentered && widget.userLocation.value == null) {
      setState(() {
        _locationCentered = false;
      });
    } else if (!_locationCentered && widget.userLocation.value != null) {
      setState(() {
        _locationCentered = true;
      });
    }
  }

  Future<void> _checkLocationServiceEnabled() async {
    final bool enabled = await Geolocator.isLocationServiceEnabled();
    if (enabled != _locationServiceEnabled) {
      setState(() {
        _locationServiceEnabled = enabled;
      });
    }
  }

  Future<void> _onPressed() async {
    // TODO(Xennis): Catch exception!
    // Check permission
    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      if (<LocationPermission>[
            LocationPermission.always,
            LocationPermission.whileInUse
          ].contains(await Geolocator.requestPermission()) ==
          false) {
        widget.onNoPermissions();
      }
    }

    // Requesting the location also enables the location service if it
    // is disabled.
    // See https://github.com/Baseflow/flutter-geolocator/issues/1034#issuecomment-1142153435
    // TODO(Xennis): Add timeout and catch exception.
    await Geolocator.getCurrentPosition();

    widget.onOkay();
  }
}
