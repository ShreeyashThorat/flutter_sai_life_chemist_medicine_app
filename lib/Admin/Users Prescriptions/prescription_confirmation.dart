import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sai_life/Admin/admin_main.dart';
import 'package:sai_life/Database/databasedata.dart';

class ConfirmRejectPrescription extends StatefulWidget {
  final String? id;
  const ConfirmRejectPrescription({Key? key, required this.id})
      : super(key: key);

  @override
  State<ConfirmRejectPrescription> createState() =>
      _ConfirmRejectPrescriptionState();
}

class _ConfirmRejectPrescriptionState extends State<ConfirmRejectPrescription> {
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
          'Detailed Prescription',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
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
          : StreamBuilder(
              stream: FirebaseData.getPrescriptions(widget.id!),
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
                  return Container(
                    margin: const EdgeInsets.all(15),
                    child: Column(
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
                                  height: 8,
                                ),
                                const Text(
                                  "Prescriptions attached by you :",
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: data["prescriptions"].length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 3,
                                            crossAxisSpacing: 3,
                                            mainAxisExtent: 200),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          height: 200,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                data["prescriptions"][index],
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 17,
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
                                                color: Colors.amber)))),
                                onPressed: reject,
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
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 17,
                              height: 50,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.amber),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ))),
                                onPressed: confirmed,
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
              }),
    );
  }

  reject() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('Prescriptions')
        .doc(widget.id!)
        .set({'Rejected': true}, SetOptions(merge: true)).then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
          (Route<dynamic> route) => false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Order Rejected')));
    });
  }

  confirmed() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('Prescriptions')
        .doc(widget.id!)
        .set({'Confirmed': true}, SetOptions(merge: true)).then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
          (Route<dynamic> route) => false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Order Rejected')));
    });
  }
}
