import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sai_life/UserScreens/prescription_full_screen_view.dart';
import 'package:sai_life/screens/dashboard.dart';

class UploadPrescriptionScreen extends StatefulWidget {
  const UploadPrescriptionScreen({super.key});

  @override
  State<UploadPrescriptionScreen> createState() =>
      _UploadPrescriptionScreenState();
}

class _UploadPrescriptionScreenState extends State<UploadPrescriptionScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // ignore: prefer_final_fields
  List<File> _prescriptions = [];
  bool isLoading = false;
  String name = "";

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final name_ = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      name = name_.data()!['Name'];
    });
  }

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
            'SAi LiFE CHEMiST',
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const PageScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Please choose image of your prescription from gallery",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        width: MediaQuery.of(context).size.width,
                        child: OutlinedButton(
                          onPressed: () => _uploadPrescription(),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                              side: MaterialStateProperty.all<BorderSide>(
                                  const BorderSide(color: Colors.teal))),
                          child: Text(
                            _prescriptions.isEmpty
                                ? 'Upload Prescription'
                                : 'Upload More Prescriptions',
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      _prescriptions.isEmpty
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 2,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text(
                                  "Prescriptions attached by you",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _prescriptions.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            PrescriptionFullScreenView(
                                                                prescription:
                                                                    _prescriptions[
                                                                        index])));
                                              },
                                              child: Container(
                                                height: 200,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  image: DecorationImage(
                                                    image: FileImage(
                                                      _prescriptions[index],
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              top: 0,
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.deepOrange,
                                                ),
                                                onPressed: () =>
                                                    showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: const Text(
                                                        'Delete prescription image?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context,
                                                                'Cancel'),
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.orange,
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            setState(() {
                                                          _prescriptions
                                                              .removeAt(index);
                                                          Navigator.pop(context,
                                                              'Cancel');
                                                        }),
                                                        child: const Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.orange,
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: const Text(
                          "Our pharmacist will call you to confirm medicines from your prescription",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black38,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              _prescriptions.isEmpty
                  ? Container()
                  : Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.teal),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ))),
                        onPressed: () => _orderMedicine(),
                        child: isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Please Wait...',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ))
                                ],
                              )
                            : const Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
            ],
          ),
        ));
  }

  Future<void> _uploadPrescription() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (image != null) {
      setState(() {
        _prescriptions.add(File(image.path));
      });
    }
  }

  Future<void> _orderMedicine() async {
    try {
      setState(() {
        isLoading = true;
      });
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String? contact = FirebaseAuth.instance.currentUser!.phoneNumber;
      final List<String> prescriptionUrls = [];

      for (final prescription in _prescriptions) {
        final Reference storageRef = FirebaseStorage.instance.ref().child(
            'prescriptions/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final UploadTask uploadTask = storageRef.putFile(prescription);
        final TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() {}));

        final String url = (await downloadUrl.ref.getDownloadURL());
        prescriptionUrls.add(url);
      }
      var rndnumber = "";
      var rnd = Random();
      for (var i = 0; i < 6; i++) {
        rndnumber = rndnumber + rnd.nextInt(9).toString();
      }
      DateTime datetime = DateTime.now();
      int currYear = datetime.year;
      int currday = datetime.day;
      int currmonth = datetime.month;
      int hour = datetime.hour;
      int minute = datetime.minute;
      int second = datetime.second;
      String dateStr = ("$currday/$currmonth/$currYear $hour:$minute:$second");
      final Map<String, dynamic> prescriptionData = {
        'Id': rndnumber,
        'C_uid': uid,
        'C_contact': contact,
        'Date': dateStr,
        'C_name': name,
        'prescriptions': prescriptionUrls,
        'Confirmed': false,
        'Rejected': false
      };
      await _firestore
          .collection('Prescriptions')
          .doc(rndnumber)
          .set(prescriptionData)
          .then((value) {
        setState(() {
          _prescriptions.clear();
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error Occured')));
    }
  }
}
