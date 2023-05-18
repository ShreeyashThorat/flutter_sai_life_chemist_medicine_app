import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sai_life/Admin/Product/edit_product.dart';
import 'package:sai_life/Admin/Product/get_product.dart';
import 'package:sai_life/Admin/Search%20Data/search_product.dart';
import 'package:sai_life/Admin/admin_main.dart';
import 'package:sai_life/Database/databasedata.dart';

class AdminProduct extends StatefulWidget {
  const AdminProduct({super.key});

  @override
  State<AdminProduct> createState() => _AdminProductState();
}

class _AdminProductState extends State<AdminProduct> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseData.getProducts(),
        builder: (BuildContext contex, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
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
                              builder: (context) => const AdminSearchProduct()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: const [
                          Text(
                            'Search medicines & health products',
                            style:
                                TextStyle(color: Colors.black38, fontSize: 18),
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
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
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
                  ))
                ],
              )),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              'No Products Available..!',
              style: GoogleFonts.righteous(fontSize: 30, color: Colors.black54),
            ));
          } else {
            var data = snapshot.data!.docs;
            return Container(
              padding: const EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SafeArea(
                  child: Column(
                children: [
                  // Search Area
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
                              builder: (context) => const AdminSearchProduct()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: const [
                          Text(
                            'Search medicines & health products',
                            style:
                                TextStyle(color: Colors.black38, fontSize: 18),
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
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: List.generate(
                          data.length,
                          (index) => Slidable(
                              endActionPane: ActionPane(
                                  extentRatio: 0.40,
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditProduct(
                                                  pname:
                                                      "${data[index]['P_Name']}")),
                                        );
                                      },
                                      backgroundColor: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10),
                                      icon: Icons.edit,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SlidableAction(
                                      onPressed: (context) =>
                                          showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text(
                                              'DDo you want to remove this product?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
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
                                                final firestoreInstance =
                                                    FirebaseFirestore.instance;
                                                final collectionRef =
                                                    firestoreInstance
                                                        .collection('Products');
                                                final documentRef =
                                                    collectionRef.where(
                                                        'P_Name',
                                                        isEqualTo: data[index]
                                                            ['P_Name']);
                                                final documentSnapshot =
                                                    await documentRef.get();
                                                await documentSnapshot
                                                    .docs.first.reference
                                                    .delete()
                                                    .then((value) {
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AdminDashboard()),
                                                      (Route<dynamic> route) =>
                                                          false);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              'Product has been deleted')));
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
                                      backgroundColor: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10),
                                      icon: Icons.delete,
                                    )
                                  ]),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GetProduct(
                                            pname: "${data[index]['P_Name']}",
                                            data: data[index])),
                                  );
                                },
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
                                                    decoration: TextDecoration
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
                                                    style:
                                                        GoogleFonts.bebasNeue(
                                                            fontSize: 24,
                                                            color:
                                                                Colors.black),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "(${(((data[index]['Price'] - data[index]['S_price']) / data[index]['Price']) * 100).toStringAsFixed(2)}%)",
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Colors.deepOrange),
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
        });
  }
}
