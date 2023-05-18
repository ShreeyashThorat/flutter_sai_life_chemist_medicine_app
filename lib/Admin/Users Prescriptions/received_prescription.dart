// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sai_life/Admin/Users%20Prescriptions/prescription_confirmation.dart';
import 'package:sai_life/Database/databasedata.dart';
import 'package:url_launcher/url_launcher.dart';

class ReceivedPrescription extends StatefulWidget {
  const ReceivedPrescription({super.key});

  @override
  State<ReceivedPrescription> createState() => _ReceivedPrescriptionState();
}

class _ReceivedPrescriptionState extends State<ReceivedPrescription> {
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
          'Received Prescriptions',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.fromLTRB(10, 10, 10, 10)),
                  elevation: MaterialStateProperty.all(0.1),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.black26))),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Text(
                    "Search By Order Id",
                    style: TextStyle(color: Colors.black38, fontSize: 18),
                  ), // <-- Text
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    // <-- Icon
                    Icons.search_rounded,
                    color: Colors.black38,
                    size: 24.0,
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<List<String>>(
              future: orderByPrescription(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<String> orderId = snapshot.data!;
                    return Expanded(
                        child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: List.generate(
                            orderId.length,
                            (index) => Container(
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15, top: 7),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade200),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            'Order Id :',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            orderId[index].toString(),
                                            style:
                                                const TextStyle(fontSize: 18),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      StreamBuilder(
                                          stream: FirebaseData.getPrescriptions(
                                              orderId[index].toString()),
                                          builder: (BuildContext contex,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (!snapshot.hasData) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                          Colors.black54),
                                                ),
                                              );
                                            } else {
                                              var data = snapshot.data!.docs[0];
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Date :',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(data["Date"],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 18))
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Text(
                                                    'Customer Name :',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5, left: 5),
                                                    child: Text(data["C_name"],
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 10),
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2) -
                                                            33,
                                                        height: 40,
                                                        child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              elevation:
                                                                  MaterialStateProperty.all(
                                                                      0),
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<Color>(
                                                                      Colors
                                                                          .white),
                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          5.0),
                                                                  side: const BorderSide(
                                                                      color: Colors
                                                                          .amber)))),
                                                          onPressed: () async {
                                                            String contact =
                                                                data[
                                                                    "C_contact"];
                                                            launch(
                                                                'tel: $contact');
                                                          },
                                                          child: const Text(
                                                            'CALL',
                                                            style: TextStyle(
                                                              fontSize: 18.0,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 4,
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 10),
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2) -
                                                            33,
                                                        height: 40,
                                                        child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              elevation:
                                                                  MaterialStateProperty
                                                                      .all(0),
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<
                                                                          Color>(
                                                                      Colors
                                                                          .amber),
                                                              shape: MaterialStateProperty.all<
                                                                      RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ))),
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ConfirmRejectPrescription(
                                                                          id: orderId[index]
                                                                              .toString())),
                                                            );
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: const [
                                                              Text(
                                                                'Next Page',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      20.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .arrow_forward,
                                                                color: Colors
                                                                    .black,
                                                                size: 18,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            }
                                          })
                                    ],
                                  ),
                                )),
                      ),
                    ));
                  } else if (snapshot.hasError) {
                    return Text('Error:${snapshot.error}');
                  } else {
                    return Center(
                      child: Text(
                        "Oops...No pending orders",
                        style: GoogleFonts.righteous(
                            fontSize: 30, color: Colors.teal.shade700),
                      ),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.black54),
                    ),
                  );
                }
              }),
        ],
      )),
    );
  }
}
