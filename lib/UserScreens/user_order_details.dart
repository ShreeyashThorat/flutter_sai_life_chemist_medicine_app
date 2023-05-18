import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sai_life/Database/databasedata.dart';
import 'package:sai_life/screens/dashboard.dart';

class UserOrderDetails extends StatefulWidget {
  final String? id;
  const UserOrderDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<UserOrderDetails> createState() => _UserOrderDetailsState();
}

class _UserOrderDetailsState extends State<UserOrderDetails> {
  bool isLoading = false;
  int active = 1;

  num wallet = 0;
  num totalAmount = 0;

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
          'Order Details',
          style: TextStyle(color: Colors.black, fontSize: 23),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
          stream: FirebaseData.getpendngOrder(widget.id!),
          builder:
              (BuildContext contex, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.black54),
                ),
              );
            } else {
              var data = snapshot.data!.docs[0];
              if (data["order_placed"] == true) {
                active = 1;
                if (data["Confirmed"] == true) {
                  active = 2;
                  if (data["Shipped"] == true) {
                    active = 3;
                    if (data["Delivered"] == true) {
                      active = 4;
                    } else {
                      active = 3;
                    }
                  } else {
                    active = 2;
                  }
                } else {
                  active = 1;
                }
              }
              return Container(
                padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const PageScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Order Id :',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(widget.id!,
                                  style: const TextStyle(fontSize: 20))
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Ordered Date :',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(data['Date'],
                                  style: const TextStyle(fontSize: 20))
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          data["Confirmed"] == true
                              ? Row(
                                  children: [
                                    const Text(
                                      'Expected Delivery :',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(data['Expected Delivery'],
                                        style: const TextStyle(fontSize: 20))
                                  ],
                                )
                              : const Text(
                                  'Please wait for confirmation from sai life',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          17,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Reciever Name :',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                      Text(data['R_name'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.orange)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        'Receiver Contact :',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                      Text(data['R_contact'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.orange)),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          17,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Customer UID :',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                      Text(data['C_uid'],
                                          maxLines: 1,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.orange)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        'Customer Contact :',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                      Text(data['C_contact'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.orange)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Receiver Address :',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(data['R_address'],
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.orange)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Total Amount :',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text("\u{20B9} ${data['Total Amount']}",
                                  style: const TextStyle(fontSize: 20))
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Payment Method :',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              data['COD'] == true
                                  ? const Text("Cash On delivery",
                                      style: TextStyle(fontSize: 20))
                                  : const Text("Online",
                                      style: TextStyle(fontSize: 20))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          EasyStepper(
                            lineType: LineType.normal,
                            activeStep: active,
                            direction: Axis.horizontal,
                            lineColor: Colors.black,
                            stepRadius: 20,
                            unreachedStepIconColor: Colors.black,
                            unreachedStepBorderColor: Colors.white,
                            finishedStepBackgroundColor: Colors.black,
                            unreachedStepBackgroundColor: Colors.white,
                            onStepReached: (index) =>
                                setState(() => active = index),
                            steps: const [
                              EasyStep(
                                icon: Icon(Icons.add_task_rounded),
                                activeIcon: Icon(Icons.add_task_rounded),
                                title: 'Order Placed',
                              ),
                              EasyStep(
                                icon: Icon(Icons.confirmation_num_outlined),
                                activeIcon:
                                    Icon(Icons.filter_center_focus_sharp),
                                title: 'Confirmed',
                              ),
                              EasyStep(
                                icon: Icon(Icons.local_shipping_outlined),
                                activeIcon: Icon(Icons.local_shipping_outlined),
                                title: 'Shipping',
                              ),
                              EasyStep(
                                icon: Icon(Icons.check_circle_outline),
                                activeIcon: Icon(Icons.check_circle_outline),
                                title: 'Delivered',
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 1,
                            color: Colors.black45,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Product Details :',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: List.generate(
                                data["Order"].length,
                                (index) => Card(
                                      elevation: 1,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        child: Row(
                                          children: [
                                            Image.network(
                                              data["Order"][index]['image'],
                                              width: 100,
                                              height: 100,
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Container(
                                              height: 100,
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  180,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data["Order"][index]
                                                        ['name'],
                                                    maxLines: 2,
                                                    style: GoogleFonts.akshar(
                                                        fontSize: 20,
                                                        color: Colors.black),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "\u{20B9} ${data["Order"][index]['price']}",
                                                        style: GoogleFonts
                                                            .bebasNeue(
                                                                fontSize: 24,
                                                                color: Colors
                                                                    .black54),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        "Qty : ${data["Order"][index]['qty']}",
                                                        style: GoogleFonts
                                                            .bebasNeue(
                                                                fontSize: 24,
                                                                color: Colors
                                                                    .black54),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                          ),
                        ],
                      ),
                    )),
                    data["COD"] == true
                        ? Row(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 15),
                                width: (MediaQuery.of(context).size.width / 2) -
                                    17,
                                height: 50,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              side: const BorderSide(
                                                  color: Colors
                                                      .deepOrangeAccent)))),
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
                                                        'Order has been cancelled')));
                                            await FirebaseFirestore.instance
                                                .collection('Orders')
                                                .doc(widget.id!)
                                                .set({'order_placed': false},
                                                    SetOptions(merge: true));
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
                                  child: const Text(
                                    'Cancel Order',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 15),
                                width: (MediaQuery.of(context).size.width / 2) -
                                    17,
                                height: 50,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.deepOrangeAccent),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ))),
                                  onPressed: () {
                                    _openCheckout();
                                    setState(() {
                                      isLoading = false;
                                      totalAmount = data['Total Amount'];
                                    });
                                  },
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
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ))
                                          ],
                                        )
                                      : Text(
                                          " PAY \u{20B9}${data['Total Amount']}",
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 15),
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          side: const BorderSide(
                                              color:
                                                  Colors.deepOrangeAccent)))),
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text(
                                      'Do you really want to cancel this order?'),
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
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('Orders')
                                            .doc(widget.id!)
                                            .set({'order_placed': false},
                                                SetOptions(merge: true));

                                        await FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .set({
                                          'wallet':
                                              wallet + data["Total Amount"]
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
                                          'Amount': data["Total Amount"]
                                        }).then((value) {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Dashboard()),
                                              (Route<dynamic> route) => false);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Order has been cancelled')));
                                        });
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
                              child: const Text(
                                'Cancel Order',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              );
            }
          }),
    );
  }

  void _openCheckout() async {
    setState(() {
      isLoading = true;
    });
    String? phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
    var options = {
      'key': 'rzp_test_pzCYxjHTCZod9O',
      'amount': totalAmount * 100,
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
      await FirebaseFirestore.instance
          .collection('Orders')
          .doc(widget.id!)
          .set({'COD': false}, SetOptions(merge: true));
    } catch (e) {
      setState(() {
        isLoading = false;
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
}
