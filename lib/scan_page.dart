import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class ScanPage extends StatefulWidget {
  ScanPage({Key key}) : super(key: key);

  @override
  _ScanPageState createState() => new _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  List<CameraDescription> cameras;
  CameraController controller;

  @override
    Widget build(BuildContext context) {
      if (controller != null) {
        return Scaffold(
          appBar: new GradientAppBar(
            title: new Text("Camera"),
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
              Navigator.pop(context);
            }),
            backgroundColorStart: Colors.blue.shade900,
            backgroundColorEnd: Colors.blue.shade400,
          ),
          body: new CameraPreview(controller),
        );
      } else {
        return Scaffold(
          appBar: new GradientAppBar(
            title: new Text("Camera"),
            backgroundColorStart: Colors.blue.shade900,
            backgroundColorEnd: Colors.blue.shade400,
          ),
        );
      }
    }
  
  @override
    void initState() {
      super.initState();
      availableCameras().then((cams) {
        cameras = cams;
        print(cameras);
        controller = new CameraController(cameras[0], ResolutionPreset.medium);
        controller.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        });
      });
    }

  @override
    void dispose() {
      controller?.dispose();
      super.dispose();
    }
}
