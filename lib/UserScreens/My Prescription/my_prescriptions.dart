import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sai_life/Database/databasedata.dart';
import 'package:sai_life/UserScreens/My%20Prescription/my_prescreption_full_screen.dart';

class MyPrescriptions extends StatefulWidget {
  const MyPrescriptions({super.key});

  @override
  State<MyPrescriptions> createState() => _MyPrescriptionsState();
}

class _MyPrescriptionsState extends State<MyPrescriptions> {
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
        padding: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<String>>(
            future: myPrescriptions(FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  List<String> orderId = snapshot.data!;
                  return Expanded(
                      child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const PageScrollPhysics(),
                    child: Column(
                      children: List.generate(
                          orderId.length,
                          (index) => Container(
                                margin: const EdgeInsets.only(top: 7),
                                padding: const EdgeInsets.all(15),
                                decoration: (index % 2 == 0)
                                    ? BoxDecoration(
                                        color: const Color.fromARGB(
                                            103, 241, 195, 125),
                                        borderRadius: BorderRadius.circular(8),
                                      )
                                    : BoxDecoration(
                                        color: const Color.fromARGB(
                                            94, 127, 212, 203),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          style: const TextStyle(fontSize: 18),
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
                                              child: CircularProgressIndicator(
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
                                                      'Ordered Date :',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(data["Date"],
                                                        style: const TextStyle(
                                                            fontSize: 18))
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                data["Rejected"] == false
                                                    ? data["Confirmed"] == false
                                                        ? const Text(
                                                            "Not Confirmed yet",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black54),
                                                          )
                                                        : const Text(
                                                            "Confirmed by sai life",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black54),
                                                          )
                                                    : const Text(
                                                        "Order Rejected",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Text(
                                                  "Prescriptions attached by you :",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  height: 200,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        data["prescriptions"]
                                                            .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        MyPrescriptionFullScreen(
                                                                            prescription:
                                                                                data["prescriptions"][index])));
                                                          },
                                                          child: Container(
                                                            height: 200,
                                                            width: 150,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    NetworkImage(
                                                                  data["prescriptions"]
                                                                      [index],
                                                                ),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
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
                      "Oops...You have not uploaded any prescription",
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
      ),
    );
  }
}
