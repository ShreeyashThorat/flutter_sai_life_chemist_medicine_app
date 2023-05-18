import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sai_life/Database/databasedata.dart';

class TotalUsers extends StatefulWidget {
  const TotalUsers({super.key});

  @override
  State<TotalUsers> createState() => _TotalUsersState();
}

class _TotalUsersState extends State<TotalUsers> {
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
                size: 18,
              ),
              onTap: () => Navigator.of(context).pop()),
          title: const Text(
            'All Customers',
            style: TextStyle(color: Colors.black, fontSize: 23),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: StreamBuilder(
            stream: FirebaseData.totalUsers(),
            builder:
                (BuildContext contex, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Image(
                      width: double.infinity,
                      image: AssetImage("assets/logos/loading.gif")),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return Center(
                    child: Text(
                  'No Products Available..!',
                  style: GoogleFonts.righteous(
                      fontSize: 30, color: Colors.black54),
                ));
              } else {
                var data = snapshot.data!.docs;
                return Container(
                  padding: const EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SafeArea(
                      child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Text(
                              "Total Users :",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              data.length.toString(),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 21),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: List.generate(
                              data.length,
                              (index) => Container(
                                    margin: const EdgeInsets.only(top: 7),
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 90,
                                              height: 90,
                                              alignment: Alignment.center,
                                              decoration: (index % 2 == 0)
                                                  ? BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              103,
                                                              241,
                                                              195,
                                                              125),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    )
                                                  : BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              94,
                                                              127,
                                                              212,
                                                              203),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                              child: Text(
                                                  data[index]['Name'][0],
                                                  style: const TextStyle(
                                                      fontSize: 35,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              alignment: Alignment.topLeft,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  148,
                                              height: 100,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data[index]['Name'],
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black54),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    data[index]['Email'],
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black54),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    data[index]['Phone No'],
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black54),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                        ),
                      ))
                    ],
                  )),
                );
              }
            }));
  }
}
