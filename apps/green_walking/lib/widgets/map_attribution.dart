import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class AttributionOptions extends LayerOptions {
  final Color color;
  final String logoAssetName;

  AttributionOptions({
    @required this.logoAssetName,
    this.color = Colors.blueGrey,
  }) : assert(logoAssetName != null);
}

class AttributionLayer extends StatelessWidget {
  final AttributionOptions options;
  final MapState map;
  final Stream<void> stream;

  AttributionLayer(this.options, this.map, this.stream);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Row(
        children: [
          Text("   "), // FIXME: Use proper spacing
          SvgPicture.asset(
            options.logoAssetName,
            semanticsLabel: 'Mapbox',
            width: 80,
            color: options.color,
          ),
          IconButton(
              icon: Icon(
                Icons.info,
                color: options.color,
              ),
              onPressed: () {
                showDialog<dynamic>(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Mapbox Map'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    text: '© Mapbox\n',
                                    style: TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launch(
                                            'https://www.mapbox.com/about/maps/');
                                      },
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: '© OpenStreetMap\n',
                                    style: TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launch(
                                            'http://www.openstreetmap.org/copyright');
                                      },
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Improve this map',
                                    style: TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launch(
                                            'https://www.mapbox.com/map-feedback/');
                                      },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            FlatButton(
                                child: Text("OK"),
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
    return AttributionLayer(options, mapState, stream);
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is AttributionOptions;
  }
}
