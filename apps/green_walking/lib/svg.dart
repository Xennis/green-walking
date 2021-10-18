import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

// flutter_svg does not support web yet. See https://github.com/dnfield/flutter_svg/issues/173
class PlatformSvgPicture {
  static Widget asset(String assetName,
      {double width,
      double height,
      BoxFit fit = BoxFit.contain,
      Color color,
      Alignment alignment = Alignment.center,
      String semanticsLabel}) {
    if (kIsWeb) {
      return Image.network('/assets/$assetName',
          width: width,
          height: height,
          fit: fit,
          color: color,
          alignment: alignment,
          semanticLabel: semanticsLabel);
    }
    return SvgPicture.asset(assetName,
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        semanticsLabel: semanticsLabel);
  }
}
