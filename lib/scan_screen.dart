import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ScanScreen extends StatefulWidget {
  ScanScreen({Key key}) : super(key: key);

  @override
  _ScanScreenState createState() => new _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<CameraDescription> cameras;
  CameraController controller;

  @override
    Widget build(BuildContext context) {
      if (controller != null) {
        return Scaffold(
          appBar: new AppBar(title: new Text("Camera"),),
          body: new CameraPreview(controller),
        );
      } else {
        return Scaffold(
          appBar: new AppBar(title: new Text("Camera"),),
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
