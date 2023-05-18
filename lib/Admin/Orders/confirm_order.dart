import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sai_life/Admin/admin_main.dart';
import 'package:sai_life/Database/databasedata.dart';

class ConfirmReject extends StatefulWidget {
  final String? id;
  const ConfirmReject({Key? key, required this.id}) : super(key: key);

  @override
  State<ConfirmReject> createState() => _ConfirmRejectState();
}

class _ConfirmRejectState extends State<ConfirmReject> {
  bool isLoading = false;
  DateTime selectedDate = DateTime.now();
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
      body: isLoading
          ? Center(
              child: Row(
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
                        color: Colors.black,
                      ))
                ],
              ),
            )
          : ListView(
              shrinkWrap: true,
              children: [
                StreamBuilder(
                    stream: FirebaseData.getpendngOrder(widget.id!),
                    builder: (BuildContext contex,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.black54),
                          ),
                        );
                      } else {
                        var data = snapshot.data!.docs[0];
                        return Container(
                          padding: const EdgeInsets.only(
                              left: 15, top: 15, right: 15),
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
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  2) -
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
                                          (MediaQuery.of(context).size.width /
                                                  2) -
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
                                            fontSize: 18,
                                            color: Colors.orange)),
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
                                height: 20,
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
                                                      const EdgeInsets.only(
                                                          top: 20),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      180,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data["Order"][index]
                                                            ['name'],
                                                        maxLines: 2,
                                                        style:
                                                            GoogleFonts.akshar(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .black),
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
                                                                    fontSize:
                                                                        24,
                                                                    color: Colors
                                                                        .black54),
                                                          ),
                                                          const Spacer(),
                                                          Text(
                                                            "Qty : ${data["Order"][index]['qty']}",
                                                            style: GoogleFonts
                                                                .bebasNeue(
                                                                    fontSize:
                                                                        24,
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
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        17,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          elevation:
                                              MaterialStateProperty.all(0),
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
                                                      color: Colors.amber)))),
                                      onPressed: () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await FirebaseFirestore.instance
                                            .collection('Orders')
                                            .doc(widget.id!)
                                            .set({
                                          'Rejected': true
                                        }, SetOptions(merge: true)).then(
                                                (value) {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AdminDashboard()),
                                              (Route<dynamic> route) => false);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content:
                                                      Text('Order Rejected')));
                                        });
                                      },
                                      child: const Text(
                                        'REJECT',
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
                                    margin: const EdgeInsets.only(top: 20),
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        17,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          elevation:
                                              MaterialStateProperty.all(0),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.amber),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ))),
                                      onPressed: () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Select Date"),
                                              content: InkWell(
                                                onTap: () {
                                                  _selectDate(context);
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 50,
                                                  color: Colors.grey.shade200,
                                                  child: Text(
                                                    "${selectedDate.toLocal()}"
                                                        .split(' ')[0],
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    _submitDate();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Submit"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Text(
                                        'CONFIRM',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }
                    })
              ],
            ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submitDate() async {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final formattedDate = formatter.format(selectedDate);
    try {
      await FirebaseFirestore.instance.collection('Orders').doc(widget.id!).set(
          {'Confirmed': true, 'Expected Delivery': formattedDate},
          SetOptions(merge: true)).then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboard()),
            (Route<dynamic> route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order marked as confirmed')));
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error saving date!")),
      );
    }
  }
}
