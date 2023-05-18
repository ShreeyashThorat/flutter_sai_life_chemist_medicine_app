import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sai_life/Admin/Orders/order_details.dart';
import 'package:sai_life/Admin/Search%20Data/search_order.dart';
import 'package:sai_life/Database/databasedata.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  int activeStep = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.fromLTRB(10, 10, 10, 10)),
                      elevation: MaterialStateProperty.all(0.1),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.black26))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchOrder()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Text(
                        "Search By Order Id",
                        style: TextStyle(color: Colors.black38, fontSize: 18),
                      ), // <-- Text
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        // <-- Icon
                        Icons.search_rounded,
                        color: Colors.black38,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
              ),
              FutureBuilder<List<String>>(
                  future: allOrder(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        List<String> orderId = snapshot.data!;
                        return Expanded(
                            child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: List.generate(
                                orderId.length,
                                (index) => Container(
                                      margin: const EdgeInsets.only(top: 7),
                                      padding: const EdgeInsets.all(15),
                                      decoration: (index % 2 == 0)
                                          ? BoxDecoration(
                                              color: const Color.fromARGB(
                                                  103, 241, 195, 125),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            )
                                          : BoxDecoration(
                                              color: const Color.fromARGB(
                                                  94, 127, 212, 203),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                'Order Id :',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                orderId[index].toString(),
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          StreamBuilder(
                                              stream:
                                                  FirebaseData.getpendngOrder(
                                                      orderId[index]
                                                          .toString()),
                                              builder: (BuildContext contex,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                              Colors.black54),
                                                    ),
                                                  );
                                                } else {
                                                  var data =
                                                      snapshot.data!.docs[0];
                                                  if (data["order_placed"] ==
                                                      true) {
                                                    activeStep = 1;
                                                    if (data["Confirmed"] ==
                                                        true) {
                                                      activeStep = 2;
                                                      if (data["Shipped"] ==
                                                          true) {
                                                        activeStep = 3;
                                                        if (data["Delivered"] ==
                                                            true) {
                                                          activeStep = 4;
                                                        } else {
                                                          activeStep = 3;
                                                        }
                                                      } else {
                                                        activeStep = 2;
                                                      }
                                                    } else {
                                                      activeStep = 1;
                                                    }
                                                  }
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            'Date :',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(data["Date"],
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          18))
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      const Text(
                                                        'Shipping Address :',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 5,
                                                                left: 5),
                                                        child: Text(
                                                            data["R_address"],
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .black)),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 20),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.5,
                                                            child: EasyStepper(
                                                              lineType: LineType
                                                                  .normal,
                                                              activeStep:
                                                                  activeStep,
                                                              direction: Axis
                                                                  .horizontal,
                                                              lineColor:
                                                                  Colors.black,
                                                              stepRadius: 15,
                                                              unreachedStepIconColor:
                                                                  Colors.black,
                                                              unreachedStepBorderColor:
                                                                  Colors.white,
                                                              finishedStepBackgroundColor:
                                                                  Colors.black,
                                                              unreachedStepBackgroundColor:
                                                                  Colors.white,
                                                              onStepReached: (index) =>
                                                                  setState(() =>
                                                                      activeStep =
                                                                          index),
                                                              steps: const [
                                                                EasyStep(
                                                                  icon: Icon(Icons
                                                                      .add_task_rounded),
                                                                  activeIcon:
                                                                      Icon(Icons
                                                                          .add_task_rounded),
                                                                  title:
                                                                      'Order Placed',
                                                                ),
                                                                EasyStep(
                                                                  icon: Icon(Icons
                                                                      .confirmation_num_outlined),
                                                                  activeIcon:
                                                                      Icon(Icons
                                                                          .filter_center_focus_sharp),
                                                                  title:
                                                                      'Confirmed',
                                                                ),
                                                                EasyStep(
                                                                  icon: Icon(Icons
                                                                      .local_shipping_outlined),
                                                                  activeIcon:
                                                                      Icon(Icons
                                                                          .local_shipping_outlined),
                                                                  title:
                                                                      'Shipping',
                                                                ),
                                                                EasyStep(
                                                                  icon: Icon(Icons
                                                                      .check_circle_outline),
                                                                  activeIcon:
                                                                      Icon(Icons
                                                                          .check_circle_outline),
                                                                  title:
                                                                      'Delivered',
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Container(
                                                              width: 40,
                                                              height: 40,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            180),
                                                              ),
                                                              child: IconButton(
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .navigate_next,
                                                                ),
                                                                onPressed: () {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                OrderDetails(id: orderId[index].toString())),
                                                                  );
                                                                },
                                                              ))
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                }
                                              })
                                        ],
                                      ),
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
            ],
          ),
        ));
  }
}
