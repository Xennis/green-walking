import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';


class AttributionOptions extends LayerOptions {
  AttributionOptions({
    required this.logoAssetName,
    this.satelliteLayer = false,
    this.color = Colors.blueGrey,
  }) : super();

  final Color color;
  final String logoAssetName;

  /// If true additional links required for the satellite layer will be
  /// displayed.
  final bool satelliteLayer;
}

class AttributionLayer extends StatelessWidget {
  const AttributionLayer(
      {Key? key,
      required this.options,
      required this.map,
      required this.stream})
      : assert(options is AttributionOptions),
        super(key: key);

  final LayerOptions options;
  final MapState map;
  final Stream<void> stream;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final AttributionOptions attrOptions = options as AttributionOptions;
    final List<Widget> links = <Widget>[
      RichText(
        text: TextSpan(
          text: '© Mapbox\n',
          style: const TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch('https://www.mapbox.com/about/maps/');
            },
        ),
      ),
      RichText(
        text: TextSpan(
          text: '© OpenStreetMap\n',
          style: const TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch('http://www.openstreetmap.org/copyright');
            },
        ),
      ),
      RichText(
        text: TextSpan(
          text: locale.improveData,
          style: const TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch('https://www.mapbox.com/map-feedback/');
            },
        ),
      ),
    ];
    if (attrOptions.satelliteLayer) {
      links.add(RichText(
        text: TextSpan(
          text: '\n© Maxar',
          style: const TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch('https://www.maxar.com');
            },
        ),
      ));
    }
    return Align(
      alignment: Alignment.bottomLeft,
      child: Row(
        children: <Widget>[
          const Text('  '), // FIXME: Use proper spacing
          SvgPicture.asset(attrOptions.logoAssetName,
              width: 80, color: attrOptions.color, semanticsLabel: 'Mapbox'),
          IconButton(
              icon: Icon(
                Icons.info,
                color: attrOptions.color,
                semanticLabel: locale.attributionInfoSemanticLabel,
              ),
              onPressed: () {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text(locale.mapAttributionTitle('Mapbox')),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: links,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                                child: Text(locale.ok.toUpperCase()),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          ],
                        ));
              })
        ],
      ),
    );
  }
}

class AttributionPlugin extends MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<void> stream) {
    return AttributionLayer(options: options, map: mapState, stream: stream);
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is AttributionOptions;
  }
}
