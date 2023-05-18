import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sai_life/Admin/Orders/order_details.dart';
import 'package:sai_life/Admin/admin_main.dart';
import 'package:sai_life/Database/databasedata.dart';

class DeliveryStatus extends StatefulWidget {
  const DeliveryStatus({super.key});

  @override
  State<DeliveryStatus> createState() => _DeliveryStatusState();
}

class _DeliveryStatusState extends State<DeliveryStatus> {
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
          'Delivery Status',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: FutureBuilder<List<String>>(
            future: tobeDelivered(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                                    left: 15, right: 15, top: 10),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(103, 241, 195, 125),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(8, 10, 8, 15),
                                child: StreamBuilder(
                                    stream: FirebaseData.getpendngOrder(
                                        orderId[index].toString()),
                                    builder: (BuildContext contex,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.black54),
                                          ),
                                        );
                                      } else {
                                        var data = snapshot.data!.docs[0];
                                        bool shipped = data["Shipped"];
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  'Order Id :',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(orderId[index].toString(),
                                                    style: const TextStyle(
                                                        fontSize: 18))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    'Date :',
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
                                            ),
                                            const Text(
                                              'Shipping Address :',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 5),
                                              child: Text(data["R_address"],
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black)),
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            120,
                                                    height: 50,
                                                    child: shipped != true
                                                        ? ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<
                                                                            Color>(
                                                                        Colors
                                                                            .white),
                                                                shape: MaterialStateProperty.all<
                                                                        RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6.0),
                                                                ))),
                                                            onPressed: () {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Orders')
                                                                  .doc(orderId[
                                                                          index]
                                                                      .toString())
                                                                  .set(
                                                                      {
                                                                    'Shipped':
                                                                        true
                                                                  },
                                                                      SetOptions(
                                                                          merge:
                                                                              true));
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                          content:
                                                                              Text('Order has been shipped')));
                                                            },
                                                            child: isLoading
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: const [
                                                                      Text(
                                                                        'Please Wait...',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              20,
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            strokeWidth:
                                                                                2,
                                                                            color:
                                                                                Colors.black,
                                                                          ))
                                                                    ],
                                                                  )
                                                                : const Text(
                                                                    'Mark As Shipped',
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
                                                          )
                                                        : ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<
                                                                            Color>(
                                                                        Colors
                                                                            .white),
                                                                shape: MaterialStateProperty.all<
                                                                        RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6.0),
                                                                ))),
                                                            onPressed:
                                                                () async {
                                                              final DateFormat
                                                                  formatter =
                                                                  DateFormat(
                                                                      'dd-MM-yyyy');
                                                              final formattedDate =
                                                                  formatter.format(
                                                                      DateTime
                                                                          .now());
                                                              try {
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Orders')
                                                                    .doc(orderId[
                                                                            index]
                                                                        .toString())
                                                                    .set({
                                                                  'Delivered':
                                                                      true,
                                                                  "Delivery Date":
                                                                      formattedDate
                                                                }, SetOptions(merge: true)).then(
                                                                        (value) {
                                                                  Navigator.pushAndRemoveUntil(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              const AdminDashboard()),
                                                                      (Route<dynamic>
                                                                              route) =>
                                                                          false);
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(const SnackBar(
                                                                          content:
                                                                              Text('Order has been shipped')));
                                                                });
                                                              } catch (e) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(SnackBar(
                                                                        content:
                                                                            Text('Error: $e')));
                                                              }
                                                            },
                                                            child: isLoading
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: const [
                                                                      Text(
                                                                        'Please Wait...',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              20,
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            strokeWidth:
                                                                                2,
                                                                            color:
                                                                                Colors.black,
                                                                          ))
                                                                    ],
                                                                  )
                                                                : const Text(
                                                                    'Delivered',
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
                                                          )),
                                                const Spacer(),
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              180),
                                                    ),
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.navigate_next,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  OrderDetails(
                                                                      id: orderId[
                                                                              index]
                                                                          .toString())),
                                                        );
                                                      },
                                                    ))
                                              ],
                                            ),
                                          ],
                                        );
                                      }
                                    }),
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
      ),
    );
  }
}
