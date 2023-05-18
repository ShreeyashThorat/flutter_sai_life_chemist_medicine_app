import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sai_life/Database/databasedata.dart';

class OrderDetails extends StatefulWidget {
  final String? id;
  const OrderDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  int active = 1;
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
      body: ListView(
        shrinkWrap: true,
        children: [
          StreamBuilder(
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
                    padding:
                        const EdgeInsets.only(left: 15, top: 15, right: 15),
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
                              'Date :',
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
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width / 2) -
                                    17,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                width: (MediaQuery.of(context).size.width / 2) -
                                    17,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          unreachedStepBorderColor: Colors.amberAccent,
                          finishedStepBackgroundColor: Colors.black,
                          unreachedStepBackgroundColor: Colors.amberAccent,
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
                              activeIcon: Icon(Icons.filter_center_focus_sharp),
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
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                180,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data["Order"][index]['name'],
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
                                                      style:
                                                          GoogleFonts.bebasNeue(
                                                              fontSize: 24,
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      "Qty : ${data["Order"][index]['qty']}",
                                                      style:
                                                          GoogleFonts.bebasNeue(
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
                  );
                }
              })
        ],
      ),
    );
  }
}
