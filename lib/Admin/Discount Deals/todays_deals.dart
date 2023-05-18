import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sai_life/Admin/Discount%20Deals/add_deals.dart';
import 'package:sai_life/Database/databasedata.dart';

class TodaysDeals extends StatefulWidget {
  const TodaysDeals({super.key});

  @override
  State<TodaysDeals> createState() => _TodaysDealsState();
}

class _TodaysDealsState extends State<TodaysDeals> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          width: MediaQuery.of(context).size.width,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const AddDeals(deal: "Todays Deals")));
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )),
                side: MaterialStateProperty.all<BorderSide>(
                    const BorderSide(color: Colors.teal))),
            child: const Text(
              'Add Product',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.teal,
              ),
            ),
          ),
        ),
        StreamBuilder(
            stream: FirebaseData.getTodaysDeals(),
            builder:
                (BuildContext contex, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return SafeArea(
                    child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 160,
                  child: Expanded(
                      child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: List.generate(
                          10,
                          (index) => Container(
                                margin: const EdgeInsets.only(top: 8),
                                width: MediaQuery.of(context).size.width,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              )),
                    ),
                  )),
                ));
              } else if (snapshot.data!.docs.isEmpty) {
                return Center(
                    child: Text(
                  'No Products Available..!',
                  style: GoogleFonts.righteous(
                      fontSize: 30, color: Colors.black54),
                ));
              } else {
                var data = snapshot.data!.docs;
                return Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 160,
                  child: SafeArea(
                      child: Column(
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: List.generate(
                              data.length,
                              (index) => Slidable(
                                  endActionPane: ActionPane(
                                      extentRatio: 0.20,
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) =>
                                              showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: const Text(
                                                  'Do you want to remove this product?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Colors.orange,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    try {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'Products')
                                                          .doc(data[index]
                                                              ['P_Name'])
                                                          .set(
                                                              {
                                                            "Todays Deals":
                                                                false,
                                                          },
                                                              SetOptions(
                                                                  merge:
                                                                      true)).then(
                                                              (value) {
                                                        Navigator.of(context)
                                                            .pop();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        'Successful')));
                                                      });
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  'Error: $e')));
                                                    }
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
                                          backgroundColor: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          icon: Icons.delete,
                                        )
                                      ]),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Card(
                                      elevation: 1,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        child: Row(
                                          children: [
                                            Image.network(
                                              data[index]['Image'],
                                              width: 100,
                                              height: 100,
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Container(
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
                                                    "${data[index]['P_Name']}",
                                                    maxLines: 2,
                                                    style: GoogleFonts.akshar(
                                                        fontSize: 20,
                                                        color: Colors.black),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "${data[index]['DrugCategory']}",
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "MRP \u{20B9}${data[index]['Price']}",
                                                    style: const TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        fontSize: 18,
                                                        color: Colors.grey),
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "\u{20B9}${data[index]['S_price']}",
                                                        maxLines: 1,
                                                        style: GoogleFonts
                                                            .bebasNeue(
                                                                fontSize: 24,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "(${(((data[index]['Price'] - data[index]['S_price']) / data[index]['Price']) * 100).toStringAsFixed(2)}%)",
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            color: Colors
                                                                .deepOrange),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))),
                        ),
                      )),
                    ],
                  )),
                );
              }
            })
      ],
    );
  }
}
