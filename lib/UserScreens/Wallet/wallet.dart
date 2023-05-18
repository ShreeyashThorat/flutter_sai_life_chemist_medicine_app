import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sai_life/Database/databasedata.dart';
import 'package:sai_life/UserScreens/Wallet/withdraw.dart';
import 'package:sai_life/screens/dashboard.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  bool isLoading = false;
  num wallet = 0;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final wallet_ = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      wallet = wallet_.data()!['wallet'];
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
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 10),
              child: const Image(
                image: NetworkImage(
                    "https://img.freepik.com/free-vector/top-up-credit-concept-illustration_114360-7244.jpg?w=740&t=st=1678766102~exp=1678766702~hmac=f6435f1efcfd2d40b2fa638135eaaaa8c9f1278b64acd11c82e343d39afc2e50"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "Current Balance is :",
                  style: GoogleFonts.arima(
                      fontSize: 30,
                      color: Colors.teal.shade700,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "\u{20B9}$wallet.00",
                  style: GoogleFonts.righteous(
                      fontSize: 30, color: Colors.teal.shade700),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseData.myWithdrawals(
                    FirebaseAuth.instance.currentUser!.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.black54),
                      ),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 143, 235, 169)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ))),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Withdraw()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Withdraw',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          "Pending payout request. You should receive the funds in your bank account within ",
                                      style: TextStyle(color: Colors.black45)),
                                  TextSpan(
                                    text: '24 hrs',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              color: const Color.fromARGB(103, 247, 210, 155),
                              alignment: Alignment.center,
                              child: const Text(
                                "Processing",
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              padding: const EdgeInsets.only(left: 30),
                              color: Colors.grey.shade100,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${data["Amount"]}.00',
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black54),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(
                                                255, 143, 235, 169)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ))),
                                onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text(
                                        'Do you really want to cancel this order?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 20),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .set({
                                            'wallet': wallet + data['Amount']
                                          }, SetOptions(merge: true));

                                          DateTime datetime = DateTime.now();
                                          int currYear = datetime.year;
                                          int currday = datetime.day;
                                          int currmonth = datetime.month;
                                          int hour = datetime.hour;
                                          int minute = datetime.minute;
                                          int second = datetime.second;
                                          String dateStr =
                                              ("$currday/$currmonth/$currYear $hour:$minute:$second");
                                          await FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .collection("Wallet")
                                              .doc()
                                              .set({
                                            'Date': dateStr,
                                            'Particular': "Order Cancelled",
                                            'Amount': data['Amount']
                                          });
                                          await document.reference
                                              .delete()
                                              .then((value) {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Dashboard()),
                                                (Route<dynamic> route) =>
                                                    false);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Withdrawal request cancelled')));
                                          });
                                        },
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                child: isLoading
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                        'Cancel request',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
