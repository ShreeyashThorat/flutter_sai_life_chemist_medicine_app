import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyPrescriptionFullScreen extends StatefulWidget {
  final String prescription;
  const MyPrescriptionFullScreen({Key? key, required this.prescription})
      : super(key: key);

  @override
  State<MyPrescriptionFullScreen> createState() =>
      _MyPrescriptionFullScreenState();
}

class _MyPrescriptionFullScreenState extends State<MyPrescriptionFullScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarIconBrightness: Brightness.dark, // status bar icons' color
      systemNavigationBarIconBrightness:
          Brightness.dark, //navigation bar icons' color
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onTap: () => Navigator.of(context).pop()),
        title: const Text(
          'Prescription',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.1,
            maxScale: 5.0,
            child: Image.network(widget.prescription)),
      ),
    );
  }
}
