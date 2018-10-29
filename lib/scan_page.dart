import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ScanPage extends StatefulWidget {
  ScanPage({Key key}) : super(key: key);
  
  @override
  _ScanPageState createState() => new _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  List<CameraDescription> cameras;
  CameraController controller;

  void _requestCameras() {
    availableCameras().then((cams) {
      cameras = cams;
      controller = new CameraController(cameras[0], ResolutionPreset.medium);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((error) {
        controller = null;
        cameras = null;
        setState(() {});
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _requestCameras();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (controller != null) {
      body = Stack(
        children: <Widget>[
          CameraPreview(controller),
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(128),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      iconSize: 32.0,
                      icon: Icon(Icons.camera_front),
                      color: Colors.grey.shade300,
                      onPressed: () {},
                    ),
                    IconButton(
                      iconSize: 48.0,
                      alignment: Alignment(0.0, 0.0),
                      icon: Icon(Icons.camera_alt),
                      onPressed: () {},
                      color: Colors.grey.shade300,
                    ),
                    Container(width: 48.0,),
                  ],
                ),
              ),
            ),
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
          ),
        ],
      );
    } else {
      body = Column(
        children: <Widget>[
          Text(
              "We need your permissions for the camera in order to scan the QR-Code."),
          RaisedButton(
            child: Text("Continue"),
            onPressed: _requestCameras,
          ),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanning"),
        leading: BackButton(),
        centerTitle: true,
      ),
      body: body,
    );
  }
}
