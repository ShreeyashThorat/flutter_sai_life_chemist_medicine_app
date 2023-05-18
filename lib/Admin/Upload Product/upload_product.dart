import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sai_life/Admin/admin_main.dart';

class UploadProductData extends StatefulWidget {
  const UploadProductData({super.key});

  @override
  State<UploadProductData> createState() => _UploadProductDataState();
}

class _UploadProductDataState extends State<UploadProductData> {
  List<List<dynamic>> _data = [];
  String? filePath;
  bool isLoading = false;

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
            'Upload Product File',
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            filePath != null
                ? Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Text(
                          filePath!,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black38,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        top: 5,
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.deepOrange,
                          ),
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Delete selected file?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Colors.orange, fontSize: 20),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      filePath = null;
                                      _data.clear();
                                    });
                                    Navigator.pop(context, 'ok');
                                  },
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                        color: Colors.orange, fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: const Text(
                      'No file selected',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
            filePath == null
                ? Container(
                    height: 50,
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    width: MediaQuery.of(context).size.width,
                    child: OutlinedButton(
                      onPressed: () => _pickFile(),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                          side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(color: Colors.teal))),
                      child: const Text(
                        'Upload File',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 50,
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.teal),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ))),
                      onPressed: () => uploadData(),
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
        ));
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    // if no file is picked
    if (result == null) return;
    filePath = result.files.first.path!;

    final input = File(filePath!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();

    setState(() {
      _data = fields;
    });
  }

  Future<void> uploadData() async {
    setState(() {
      isLoading = true;
    });
    for (var element
        in _data.skip(1)) // for skip first value bcs its contain name
    {
      try {
        await FirebaseFirestore.instance
            .collection('Products')
            .doc(element[0])
            .set({
          'P_Name': element[0],
          'DrugCategory': element[1],
          'Price': element[3],
          'S_price': element[4],
          'Image': element[6],
          'Description': element[5],
          'Ingredients': element[2],
        }).then((value) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboard()),
          );
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        debugPrint('Error adding product: $e');
      }
    }
  }
}
