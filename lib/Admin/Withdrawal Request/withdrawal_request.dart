import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sai_life/Database/databasedata.dart';

import '../admin_main.dart';

class WithdrawalRequest extends StatefulWidget {
  const WithdrawalRequest({super.key});

  @override
  State<WithdrawalRequest> createState() => _WithdrawalRequestState();
}

class _WithdrawalRequestState extends State<WithdrawalRequest> {
  bool dropDown = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.teal, // transparent status bar
      systemNavigationBarColor: Colors.transparent, // navigation bar color
      statusBarIconBrightness: Brightness.dark, // status bar icons' color
      systemNavigationBarIconBrightness: Brightness.dark,
      //navigation bar icons' color
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
          'Withdrawal Request',
          style: TextStyle(color: Colors.black, fontSize: 23),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: FutureBuilder<List<String>>(
            future: withdrawalRequest(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  List<String> id = snapshot.data!;
                  return Expanded(
                      child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: List.generate(
                          id.length,
                          (index) => Container(
                                margin: const EdgeInsets.only(
                                    left: 15, right: 15, top: 7),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: StreamBuilder(
                                    stream: FirebaseData.getWithdrawalRequest(
                                        id[index].toString()),
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
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  'Withdrawal Id :',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black54),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  data['Id'],
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Requested Date :',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black54),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(data["Requested Date"],
                                                    style: const TextStyle(
                                                        fontSize: 18))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Requested Amount :',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black54),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    "\u{20B9} ${data["Amount"]}.00",
                                                    style: const TextStyle(
                                                        fontSize: 18))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Bank Details :',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black54),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                dropDown == false
                                                    ? InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            dropDown = true;
                                                          });
                                                        },
                                                        child: const Icon(Icons
                                                            .arrow_drop_up))
                                                    : InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            dropDown = false;
                                                          });
                                                        },
                                                        child: const Icon(Icons
                                                            .arrow_drop_down))
                                              ],
                                            ),
                                            dropDown == true
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  138,
                                                              child: Text(
                                                                  "${data['Beneficiary Name']}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          18)),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Clipboard.setData(
                                                                    ClipboardData(
                                                                        text: data[
                                                                            'Beneficiary Name']));
                                                              },
                                                              child: const Icon(
                                                                Icons.copy,
                                                                size: 15,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  130,
                                                              child: Text(
                                                                  "${data['Bank Name']}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          18)),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Clipboard.setData(
                                                                    ClipboardData(
                                                                        text: data[
                                                                            'Bank Name']));
                                                              },
                                                              child: const Icon(
                                                                Icons.copy,
                                                                size: 15,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  130,
                                                              child: Text(
                                                                  "${data['IFSC code']}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          18)),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Clipboard.setData(
                                                                    ClipboardData(
                                                                        text: data[
                                                                            'IFSC code']));
                                                              },
                                                              child: const Icon(
                                                                Icons.copy,
                                                                size: 15,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  130,
                                                              child: Text(
                                                                  "${data['Account Number']}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          18)),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Clipboard.setData(
                                                                    ClipboardData(
                                                                        text: data[
                                                                            'Account Number']));
                                                              },
                                                              child: const Icon(
                                                                Icons.copy,
                                                                size: 15,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2),
                                              height: 40,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all(0),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.amber),
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ))),
                                                onPressed: () async {
                                                  try {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'Withdrawals')
                                                        .doc(id[index]
                                                            .toString())
                                                        .set(
                                                            {
                                                          'Processed': true,
                                                        },
                                                            SetOptions(
                                                                merge:
                                                                    true)).then(
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
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      'Withdrawal Request Processed')));
                                                    });
                                                  } catch (error) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              "Error saving date!")),
                                                    );
                                                  }
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: const [
                                                    Text(
                                                      'Continue',
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward,
                                                      color: Colors.black,
                                                      size: 18,
                                                    )
                                                  ],
                                                ),
                                              ),
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
                      "No data available....",
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
