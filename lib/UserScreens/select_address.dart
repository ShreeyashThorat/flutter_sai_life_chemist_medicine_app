import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_cart/fancy_cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sai_life/Database/databasedata.dart';
import 'package:sai_life/UserScreens/add_address.dart';
import 'package:sai_life/screens/dashboard.dart';

class SelectAddress extends StatefulWidget {
  const SelectAddress({super.key});

  @override
  State<SelectAddress> createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  TextEditingController fullName = TextEditingController();
  TextEditingController contact = TextEditingController();

  var product = [];
  String address = "";
  bool isLoading = false;
  bool isLoading2 = false;
  num totalAmount = 0;

  num wallet = 0;
  final _razorpay = Razorpay();
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccessHandler);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, paymentErrorHandler);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWalletHandler);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
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
      body: StreamBuilder(
          stream:
              FirebaseData.getAddress(FirebaseAuth.instance.currentUser!.uid),
          builder:
              (BuildContext contex, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.black54),
                ),
              );
            } else {
              var data = snapshot.data!.docs;
              return Padding(
                padding: const EdgeInsets.all(15),
                child: ListView(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Receiver Name',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '*',
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: fullName,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                labelText: 'Full Name',
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
                          margin: const EdgeInsets.only(top: 20),
                          child: Row(
                            children: const [
                              Text(
                                'Receiver Contact',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '*',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextField(
                            maxLength: 10,
                            controller: contact,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                labelText: 'Contact no',
                                prefixIcon: Icon(Icons.phone_iphone_outlined,
                                    color: Colors.black),
                                prefixText: '+91-',
                                prefixStyle:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                                labelStyle: TextStyle(
                                    fontSize: 20, color: Colors.grey)),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                            cursorColor: Colors.grey,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: const Text(
                            'Select Shipping Address',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        CartWidget(cartBuilder: (controller) {
                          for (var i = 0; i < controller.cartList.length; i++) {
                            product.add({
                              'name': controller.cartList[i].name,
                              'image': controller.cartList[i].image,
                              'price': controller.cartList[i].price,
                              'qty': controller.cartList[i].quantity,
                            });
                          }
                          return Column(
                            children: [
                              Column(
                                children: List.generate(
                                    data.length,
                                    (index) => Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                address =
                                                    data[index]['Address'];
                                                totalAmount = (controller
                                                        .getTotalPrice()
                                                        .round() +
                                                    40);
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: address ==
                                                          data[index]['Address']
                                                      ? const Color.fromARGB(
                                                          94, 127, 212, 203)
                                                      : Colors.white,
                                                  border: address ==
                                                          data[index]['Address']
                                                      ? Border.all(
                                                          color: Colors.green)
                                                      : Border.all(
                                                          color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              padding: const EdgeInsets.all(15),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                data[index]['Address'],
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        )),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Text(
                                "You have \u{20B9}${wallet.toString()} in your wallet",
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              wallet > totalAmount || wallet == totalAmount
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 0),
                                      width: MediaQuery.of(context).size.width,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(0),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.teal),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ))),
                                        onPressed: walletPay,
                                        child: const Text(
                                          "Pay Using Wallet",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 15),
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2) -
                                              17,
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                                elevation: MaterialStateProperty.all(
                                                    0),
                                                backgroundColor:
                                                    MaterialStateProperty.all<Color>(
                                                        Colors.white),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5.0),
                                                        side: const BorderSide(
                                                            color: Colors.teal)))),
                                            onPressed: cod,
                                            child: isLoading
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Text(
                                                        'Please Wait...',
                                                        style: TextStyle(
                                                            fontSize: 18),
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
                                                    'Cash On Delivery',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.teal,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 15),
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2) -
                                              17,
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        0),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.teal),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ))),
                                            onPressed: () async {
                                              if (fullName.text.isEmpty ||
                                                  contact.text.isEmpty) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Please provide receiver name and contact details')));
                                              } else if (address == "") {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Please Select Shipping Address')));
                                              } else {
                                                setState(() {
                                                  isLoading2 = true;
                                                });
                                                _openCheckout();
                                              }
                                            },
                                            child: Text(
                                              "Pay  \u{20B9}${(controller.getTotalPrice().round() + 40) - wallet}",
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              // Payment
                            ],
                          );
                        })
                      ],
                    ),
                  ],
                ),
              );
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddAddress()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add New Address'),
      ),
    );
  }

  void _openCheckout() async {
    String? phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
    num payableAmount = totalAmount - wallet;
    var options = {
      'key': 'rzp_test_pzCYxjHTCZod9O',
      'amount': payableAmount * 100,
      'name': 'Sai Life Chemist',
      'description': 'Medicine',
      'prefill': {'contact': phoneNumber},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> paymentSuccessHandler(PaymentSuccessResponse response) async {
    // print('Payment success');
    try {
      String cUid = FirebaseAuth.instance.currentUser!.uid;
      String? cContact = FirebaseAuth.instance.currentUser!.phoneNumber;
      String rname = fullName.text;
      String rcontact = contact.text;
      DateTime datetime = DateTime.now();
      int currYear = datetime.year;
      int currday = datetime.day;
      int currmonth = datetime.month;
      int hour = datetime.hour;
      int minute = datetime.minute;
      int second = datetime.second;
      String dateStr = ("$currday/$currmonth/$currYear $hour:$minute:$second");
      var rndnumber = "";
      var rnd = Random();
      for (var i = 0; i < 6; i++) {
        rndnumber = rndnumber + rnd.nextInt(9).toString();
      }
      await FirebaseFirestore.instance.collection('Orders').doc(rndnumber).set({
        'Id': rndnumber,
        'C_uid': cUid,
        'C_contact': cContact,
        'R_name': rname,
        'R_contact': rcontact,
        'R_address': address,
        'Date': dateStr,
        'COD': false,
        'Total Amount': totalAmount,
        'order_placed': true,
        'Confirmed': false,
        'Shipped': false,
        'Delivered': false,
        'Rejected': false,
        'Order': FieldValue.arrayUnion(product),
      });
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'wallet': 0}, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Wallet")
          .doc()
          .set({
        'Date': dateStr,
        'Particular': "Order Placed",
        'Amount': wallet
      }).then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()),
            (Route<dynamic> route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your order has been placed')));
      });
    } catch (e) {
      setState(() {
        isLoading = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error Occured')));
    }
  }

  void paymentErrorHandler(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Payment error')));
  }

  void externalWalletHandler(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('External wallet')));
  }

  // Pay Using Wallet
  walletPay() async {
    if (fullName.text.isEmpty || contact.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please provide receiver name and contact details')));
    } else if (address == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Select Shipping Address')));
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        num wallet_ = wallet - totalAmount;
        String cUid = FirebaseAuth.instance.currentUser!.uid;
        String? cContact = FirebaseAuth.instance.currentUser!.phoneNumber;
        String rname = fullName.text;
        String rcontact = contact.text;
        DateTime datetime = DateTime.now();
        int currYear = datetime.year;
        int currday = datetime.day;
        int currmonth = datetime.month;
        int hour = datetime.hour;
        int minute = datetime.minute;
        int second = datetime.second;
        String dateStr =
            ("$currday/$currmonth/$currYear $hour:$minute:$second");
        var rndnumber = "";
        var rnd = Random();
        for (var i = 0; i < 6; i++) {
          rndnumber = rndnumber + rnd.nextInt(9).toString();
        }
        await FirebaseFirestore.instance
            .collection('Orders')
            .doc(rndnumber)
            .set({
          'Id': rndnumber,
          'C_uid': cUid,
          'C_contact': cContact,
          'R_name': rname,
          'R_contact': rcontact,
          'R_address': address,
          'Date': dateStr,
          'COD': false,
          'Total Amount': totalAmount,
          'order_placed': true,
          'Confirmed': false,
          'Shipped': false,
          'Delivered': false,
          'Rejected': false,
          'Order': FieldValue.arrayUnion(product),
        });
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({'wallet': wallet_}, SetOptions(merge: true));

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Wallet")
            .doc()
            .set({
          'Date': dateStr,
          'Particular': "Order Placed",
          'Amount': totalAmount
        }).then((value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
              (Route<dynamic> route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Your order has been placed')));
        });
      } catch (e) {
        setState(() {
          isLoading = true;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Error Occured')));
      }
    }
  }

  // Cash On Delivery
  cod() async {
    if (fullName.text.isEmpty || contact.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please provide receiver name and contact details')));
    } else if (address == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Select Shipping Address')));
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        String cUid = FirebaseAuth.instance.currentUser!.uid;
        String? cContact = FirebaseAuth.instance.currentUser!.phoneNumber;
        String rname = fullName.text;
        String rcontact = contact.text;
        DateTime datetime = DateTime.now();
        int currYear = datetime.year;
        int currday = datetime.day;
        int currmonth = datetime.month;
        int hour = datetime.hour;
        int minute = datetime.minute;
        int second = datetime.second;
        String dateStr =
            ("$currday/$currmonth/$currYear $hour:$minute:$second");
        var rndnumber = "";
        var rnd = Random();
        for (var i = 0; i < 6; i++) {
          rndnumber = rndnumber + rnd.nextInt(9).toString();
        }
        await FirebaseFirestore.instance
            .collection('Orders')
            .doc(rndnumber)
            .set({
          'Id': rndnumber,
          'C_uid': cUid,
          'C_contact': cContact,
          'R_name': rname,
          'R_contact': rcontact,
          'R_address': address,
          'Date': dateStr,
          'COD': true,
          'Total Amount': totalAmount,
          'order_placed': true,
          'Confirmed': false,
          'Shipped': false,
          'Delivered': false,
          'Rejected': false,
          'Order': FieldValue.arrayUnion(product),
        }).then((value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
              (Route<dynamic> route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Your order has been placed')));
        });
      } catch (e) {
        setState(() {
          isLoading = true;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Error Occured')));
      }
    }
  }
}
