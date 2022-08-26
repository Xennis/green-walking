import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationButton extends StatefulWidget {
  const LocationButton(
      {super.key, required this.onOkay, required this.onNoPermissions});

  final VoidCallback onOkay;
  final VoidCallback onNoPermissions;

  @override
  _LocationButtonState createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  bool _locationServiceEnabled = true;

  @override
  void initState() {
    super.initState();
    Geolocator.isLocationServiceEnabled().then((bool value) {
      if (value == _locationServiceEnabled) {
        return;
      }
      setState(() {
        _locationServiceEnabled = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          onPressed: _onPressed,
          child: Icon(
            _locationServiceEnabled
                ? Icons.location_searching
                : Icons.location_disabled,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _onPressed() async {
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

    // Check enabled
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      // See https://github.com/Baseflow/flutter-geolocator/issues/1034#issuecomment-1142153435
      await Geolocator.getCurrentPosition();
      enabled = await Geolocator.isLocationServiceEnabled();
    }
    if (enabled != _locationServiceEnabled) {
      setState(() {
        _locationServiceEnabled = enabled;
      });
    }

    widget.onOkay();
  }
}
