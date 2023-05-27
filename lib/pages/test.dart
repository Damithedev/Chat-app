import 'package:flutter/material.dart';
import 'dart:ui';

class BlurScaffold extends StatefulWidget {
  @override
  _BlurScaffoldState createState() => _BlurScaffoldState();
}

class _BlurScaffoldState extends State<BlurScaffold> {
  bool _showBlur = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blur Scaffold'),
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              'This is the content of the scaffold',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          if (_showBlur)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      'This is the blurred content of the scaffold',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showBlur = !_showBlur;
          });
        },
        child: Icon(Icons.blur_on),
      ),
    );
  }
}
