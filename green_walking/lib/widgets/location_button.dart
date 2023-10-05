import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

enum UserLocationTracking { no, position, positionBearing }

class LocationButton extends StatefulWidget {
  const LocationButton(
      {super.key, required this.onOkay, required this.onNoPermissions, required this.trackUserLocation});

  final void Function(bool) onOkay;
  final VoidCallback onNoPermissions;
  final ValueNotifier<UserLocationTracking> trackUserLocation;

  @override
  State<LocationButton> createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  late final Timer _timer;

  bool _locationServiceEnabled = true;

  @override
  void initState() {
    super.initState();

    _checkLocationServiceEnabled();
    _timer = Timer.periodic(const Duration(seconds: 1, microseconds: 500), (Timer result) {
      _checkLocationServiceEnabled();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18.0, right: 18.0),
        child: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            onPressed: _onPressed,
            child: ValueListenableBuilder<UserLocationTracking>(
                valueListenable: widget.trackUserLocation,
                builder: (context, value, child) {
                  final IconData icon = _locationServiceEnabled
                      ? value == UserLocationTracking.position
                          ? Icons.my_location
                          : value == UserLocationTracking.positionBearing
                              ? Icons.arrow_upward
                              : Icons.location_searching
                      : Icons.location_disabled;

                  return Icon(
                    icon,
                    size: 27,
                    color: Colors.white,
                  );
                })),
      ),
    );
  }

  void _checkLocationServiceEnabled() async {
    final bool enabled = await Geolocator.isLocationServiceEnabled();
    if (enabled != _locationServiceEnabled) {
      setState(() {
        _locationServiceEnabled = enabled;
      });
    }
  }

  void _onPressed() async {
    bool permissionGranted = false;

    // Check permission
    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      // TODO(Xennis): Catch exception!
      if (<LocationPermission>[LocationPermission.always, LocationPermission.whileInUse]
              .contains(await Geolocator.requestPermission()) ==
          false) {
        widget.onNoPermissions();
        return;
      }

      permissionGranted = true;
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      // Requesting the location also enables the location service if it
      // is disabled.
      // See https://github.com/Baseflow/flutter-geolocator/issues/1034#issuecomment-1142153435
      // TODO(Xennis): Add timeout and catch exception.
      await Geolocator.getCurrentPosition();
    }

    widget.onOkay(permissionGranted);
  }
}
