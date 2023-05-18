import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sai_life/screens/dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BankAccount extends StatefulWidget {
  const BankAccount({super.key});

  @override
  State<BankAccount> createState() => _BankAccountState();
}

class _BankAccountState extends State<BankAccount> {
  TextEditingController name = TextEditingController();
  TextEditingController account = TextEditingController();
  TextEditingController cAccount = TextEditingController();
  TextEditingController ifsc = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    account.dispose();
    cAccount.dispose();
    ifsc.dispose(); // dispose of the controller when the widget is removed from the tree
    super.dispose();
  }

  late String ifscCode;
  String _bankName = '';
  String _branchName = '';
  String err = '';
  bool isLoading = false;

  Future<Map<String, dynamic>> fetchBankDetails(String ifscCode) async {
    final response =
        await http.get(Uri.parse('https://ifsc.razorpay.com/$ifscCode'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch bank details');
    }
  }

  void _updateBankDetails() async {
    try {
      final bankDetails = await fetchBankDetails(ifscCode);

      setState(() {
        _bankName = bankDetails['BANK'];
        _branchName = bankDetails['BRANCH'];
      });
    } catch (e) {
      setState(() {
        err = 'Invalid IFSC code';
      });
    }
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
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Dashboard()),
                )),
        title: const Text(
          'Shipping Details',
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(15.0),
        child: SafeArea(
            child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const PageScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: TextField(
                      controller: ifsc,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'IFSC Code',
                          prefixIcon: Icon(Icons.account_balance_sharp,
                              color: Colors.black),
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.grey)),
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      cursorColor: Colors.grey,
                      onChanged: (value) {
                        ifscCode = value;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.teal.shade200),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ))),
                      onPressed: () {
                        _updateBankDetails();
                      },
                      child: isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Please Wait...',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ))
                              ],
                            )
                          : const Text(
                              'Get Bank Details',
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
                  _bankName != ''
                      ? Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Bank Name :",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  _bankName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Branch Name :",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  _branchName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      : Text(
                          err,
                          style:
                              const TextStyle(fontSize: 15, color: Colors.red),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  _bankName != ''
                      ? Column(
                          children: [
                            Container(
                              height: 2,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey.shade200,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: TextField(
                                controller: name,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    labelText: 'Beneficiary Name',
                                    prefixIcon: Icon(Icons.person_outline,
                                        color: Colors.black),
                                    labelStyle: TextStyle(
                                        fontSize: 20, color: Colors.grey)),
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black),
                                cursorColor: Colors.grey,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: TextField(
                                controller: account,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    labelText: 'Account number',
                                    prefixIcon: Icon(
                                        Icons.account_balance_outlined,
                                        color: Colors.black),
                                    labelStyle: TextStyle(
                                        fontSize: 20, color: Colors.grey)),
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black),
                                cursorColor: Colors.grey,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: TextField(
                                controller: cAccount,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    labelText: 'Account number',
                                    prefixIcon: Icon(
                                        Icons.account_balance_outlined,
                                        color: Colors.black),
                                    labelStyle: TextStyle(
                                        fontSize: 20, color: Colors.grey)),
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black),
                                cursorColor: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      : Container()
                ],
              ),
            )),
            _bankName != ''
                ? Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.teal.shade200),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ))),
                      onPressed: storeBank,
                      child: isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Please Wait...',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ))
                              ],
                            )
                          : const Text(
                              'Add Bank Details',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                    ),
                  )
                : Container()
          ],
        )),
      ),
    );
  }

  storeBank() async {
    String fname = name.text;
    String faccount = account.text;
    String caccount = cAccount.text;

    if (fname.isEmpty || faccount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please provide all necessary details')));
    } else if (caccount != faccount) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account Number does not match')));
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        String uid = FirebaseAuth.instance.currentUser!.uid.toString();
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('Bank Details')
            .doc()
            .set({
          'Bank': _bankName,
          'Branch': _branchName,
          'B Name': fname,
          'IFSC': ifscCode,
          'Account No': faccount
        }).then((value) {
          Navigator.of(context).pop();
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
}
