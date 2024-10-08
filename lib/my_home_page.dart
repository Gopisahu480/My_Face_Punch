import 'dart:async';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:updated_face_punching_app/current_location.dart';
import 'package:updated_face_punching_app/date_time.dart';


List<CameraDescription>? cameras;

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  CameraController? controller;
  String imagePath = "";
  late DateTime currentTime;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras![0], ResolutionPreset.max);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    // Initialize currentTime
    currentTime = DateTime.now();

    // Update currentTime every second
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller!.value.isInitialized) {
      return Container();
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 5, 81, 143),
          title: const Text(
            'Attendance Punch',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        body: SafeArea(
          child: Container(
            color: Colors.white54,
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    DateTimeDisplay(currentTime: currentTime),
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        DottedBorder(
                          dashPattern: [12, 12],
                          color: Color(0xB299B5C8),
                          borderType: BorderType.Circle,
                          child: SizedBox(width: 300, height: 300),
                        ),
                        DottedBorder(
                          dashPattern: [12, 12],
                          color: Color(0xCF7BA7C5),
                          borderType: BorderType.Circle,
                          child: SizedBox(width: 270, height: 270),
                        ),
                        Positioned(
                          child: Container(
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 15,
                                  offset: const Offset(2, 5),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: AspectRatio(
                                aspectRatio: controller!.value.aspectRatio,
                                child: CameraPreview(controller!),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 35,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              final image = await controller!.takePicture();
                              setState(() {
                                imagePath = image.path;
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Color.fromARGB(255, 5, 81, 143),
                            maximumSize: Size(280, 80),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, size: 18),
                              SizedBox(width: 5),
                              Text("CLICK HERE TO PUNCH"),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Homepage1(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
