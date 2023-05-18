import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sai_life/Database/databasedata.dart';
import 'package:sai_life/UserScreens/product_details.dart';

class TrendingDealsProduct extends StatefulWidget {
  const TrendingDealsProduct({super.key});

  @override
  State<TrendingDealsProduct> createState() => _TrendingDealsProductState();
}

class _TrendingDealsProductState extends State<TrendingDealsProduct> {
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
          'Todays Deals',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder(
          stream: FirebaseData.getTrendingDeals(),
          builder:
              (BuildContext contex, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                padding: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SafeArea(
                    child: Column(
                  children: [
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
                style:
                    GoogleFonts.righteous(fontSize: 30, color: Colors.black54),
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
                    Expanded(
                        child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          ...List.generate(
                              data.length,
                              (index) => GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductDetails(
                                                pname:
                                                    "${data[index]['P_Name']}",
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
                                  ))
                        ],
                      ),
                    ))
                  ],
                )),
              );
            }
          }),
    );
  }
}
