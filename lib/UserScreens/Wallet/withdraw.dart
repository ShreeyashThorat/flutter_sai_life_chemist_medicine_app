import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sai_life/Database/databasedata.dart';
import 'package:sai_life/UserScreens/Bank%20Account/bank_account.dart';
import 'package:random_string/random_string.dart';
import 'package:sai_life/screens/dashboard.dart';

class Withdraw extends StatefulWidget {
  const Withdraw({super.key});

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  TextEditingController amount = TextEditingController();
  bool isAmount = false;
  bool isLoading = false;
  num wallet = 0;
  String bank = "";
  String account = "";
  String ifsc = "";
  String bName = "";

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  void dispose() {
    amount.dispose();
    super.dispose();
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
        child: SafeArea(
          child: Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const PageScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "\u{20B9}$wallet.00",
                        style: GoogleFonts.arima(
                            fontSize: 20, color: Colors.black),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Available",
                        style: GoogleFonts.arima(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    height: 50,
                    child: TextField(
                      onChanged: (data) {
                        if (amount.text.isEmpty) {
                          isAmount = false;
                        } else {
                          isAmount = true;
                        }
                        setState(() {});
                      },
                      controller: amount,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.3),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide:
                                BorderSide(color: Colors.black, width: 0.3),
                          ),
                          labelText: 'Amount to withdraw',
                          labelStyle:
                              TextStyle(fontSize: 18, color: Colors.grey)),
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black54),
                      cursorColor: Colors.grey,
                    ),
                  ),
                  isAmount
                      ? StreamBuilder(
                          stream: FirebaseData.getBanks(
                              FirebaseAuth.instance.currentUser!.uid),
                          builder: (BuildContext contex,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.black54),
                                ),
                              );
                            } else if (snapshot.data!.docs.isEmpty) {
                              return Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    width: MediaQuery.of(context).size.width,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color.fromARGB(
                                                      255, 250, 192, 106)),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ))),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const BankAccount()),
                                        );
                                      },
                                      child: isLoading
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Text(
                                                  'Please Wait...',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.black,
                                                    ))
                                              ],
                                            )
                                          : const Text(
                                              'Add Bank Account',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            } else {
                              var data = snapshot.data!.docs;
                              return Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Select bank To Withdraw this amount',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Column(
                                      children: List.generate(
                                          data.length,
                                          (index) => Container(
                                                margin: const EdgeInsets.only(
                                                    top: 10),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      bank =
                                                          data[index]['Bank'];
                                                      ifsc =
                                                          data[index]['IFSC'];
                                                      account = data[index]
                                                          ['Account No'];
                                                      bName =
                                                          data[index]['B Name'];
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: bank ==
                                                                data[index]
                                                                    ['Bank']
                                                            ? const Color.fromARGB(
                                                                103, 241, 195, 125)
                                                            : Colors.white,
                                                        border: bank ==
                                                                data[index]
                                                                    ['Bank']
                                                            ? Border.all(
                                                                color: Colors
                                                                    .orange)
                                                            : Border.all(
                                                                color: Colors
                                                                    .grey),
                                                        borderRadius:
                                                            BorderRadius.circular(5.0)),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              "Bank Name :",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              data[index]
                                                                  ['Bank'],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              "IFSC Code :",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              data[index]
                                                                  ['IFSC'],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              "Account Number :",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              data[index][
                                                                  'Account No'],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              "Beneficiary Name :",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              data[index]
                                                                  ['B Name'],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                              );
                            }
                          })
                      : Container(),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 143, 235, 169)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ))),
                      onPressed: () async {
                        double withdrawal = double.parse(amount.text);
                        num amt = withdrawal.round();
                        if (amount.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please enter the amount 1st')));
                        } else if (amt > wallet) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'Withdrawal amount should be less than current balance')));
                        } else if (bank == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Select your bank to withdraw your money')));
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            String code = randomAlphaNumeric(6);
                            String uid = FirebaseAuth.instance.currentUser!.uid;
                            DateTime datetime = DateTime.now();
                            int currYear = datetime.year;
                            int currday = datetime.day;
                            int currmonth = datetime.month;
                            int hour = datetime.hour;
                            int minute = datetime.minute;
                            int second = datetime.second;
                            String dateStr =
                                ("$currday/$currmonth/$currYear $hour:$minute:$second");
                            String date =
                                ("$currday-$currmonth-$currYear $hour:$minute:$second");
                            await FirebaseFirestore.instance
                                .collection('Withdrawals')
                                .doc(code)
                                .set({
                              'Id': code,
                              'User': uid,
                              'Beneficiary Name': bName,
                              'Bank Name': bank,
                              'Account Number': account,
                              'IFSC code': ifsc,
                              'Amount': amt,
                              'Pending': true,
                              'Processed': false,
                              'Requested Date': date,
                              'Processed Date': '',
                            });

                            num walletamt = wallet - amt;
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .set({'wallet': walletamt},
                                    SetOptions(merge: true));

                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("Wallet")
                                .doc()
                                .set({
                              'Date': dateStr,
                              'Particular': "Withdraw",
                              'Amount': amt
                            }).then((value) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Dashboard()),
                                  (Route<dynamic> route) => false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Withdrawal request placed')));
                            });
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Error Occured')));
                          }
                        }
                      },
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
                              'Request to withdraw',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  StreamBuilder(
                      stream: FirebaseData.getTransactions(
                          FirebaseAuth.instance.currentUser!.uid),
                      builder: (BuildContext contex,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.black54),
                            ),
                          );
                        } else {
                          var data = snapshot.data!.docs;
                          int length;
                          if (data.length < 6) {
                            length = data.length;
                          } else {
                            length = 6;
                          }
                          return Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_outlined,
                                    color: Colors.black45,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "Recent Transactions",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black54),
                                  ),
                                  const Spacer(),
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "View All",
                                            style: const TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                fontSize: 15,
                                                color: Colors.deepOrangeAccent,
                                                fontWeight: FontWeight.bold),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {}),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                  children: List.generate(
                                      length,
                                      (index) => Column(
                                            children: [
                                              Container(
                                                color: Colors.grey.shade200,
                                                height: 2,
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding: const EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      data[index]['Date'],
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                    const Spacer(),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Container(
                                                          width: 120,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 5,
                                                                  bottom: 5),
                                                          color: data[index][
                                                                      'Particular'] !=
                                                                  "Order Cancelled"
                                                              ? const Color
                                                                      .fromARGB(
                                                                  103,
                                                                  247,
                                                                  210,
                                                                  155)
                                                              : const Color
                                                                      .fromARGB(
                                                                  94,
                                                                  127,
                                                                  212,
                                                                  203),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            data[index]
                                                                ['Particular'],
                                                            style: TextStyle(
                                                              color: data[index]
                                                                          [
                                                                          'Particular'] !=
                                                                      "Order Cancelled"
                                                                  ? Colors
                                                                      .orange
                                                                  : Colors
                                                                      .green,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 10),
                                                            child: data[index][
                                                                        'Particular'] !=
                                                                    "Order Cancelled"
                                                                ? Text(
                                                                    "-${data[index]['Amount']}.00",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .red
                                                                          .shade600,
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    "+${data[index]['Amount']}.00",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .green
                                                                          .shade600,
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                                  )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ))),
                            ],
                          );
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
