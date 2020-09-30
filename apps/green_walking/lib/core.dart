import 'package:flutter/material.dart';
import 'package:green_walking/types/place.dart';

const String privacyPolicyUrl =
    'https://raw.githubusercontent.com/Xennis/green-walking/master/web/privacy/privacy-policy.md';

String truncateString(String myString, int cutoff) {
  if (myString == null) {
    return null;
  }
  if (cutoff == null || cutoff < 1) {
    return null;
  }
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}

MaterialColor placeTypeToColor(String type) {
  switch (type) {
    case Place.TypeMonument:
      return Colors.brown;
      break;
    case Place.TypeNature:
      return Colors.green;
    default:
      return Colors.pink;
  }
}
