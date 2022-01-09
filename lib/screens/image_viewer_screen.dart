import 'package:flutter/material.dart';

class ImageViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String url = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('data'),
        ),
        body: Center(
          child: Container(
              clipBehavior: Clip.none,
              child: InteractiveViewer(child: Image.network(url))),
        ));
  }
}
