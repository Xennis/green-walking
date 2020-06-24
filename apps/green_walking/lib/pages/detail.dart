import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class DetailPageArguments {
  final String name;

  DetailPageArguments(this.name);
}

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final DetailPageArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(args.name),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: Center(
        child: Column(
          children: [Text(args.name)],
        ),
      ),
    );
  }
}
