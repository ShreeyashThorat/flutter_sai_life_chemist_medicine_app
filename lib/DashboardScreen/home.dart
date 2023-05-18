// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sai_life/Database/databasedata.dart';
import 'package:sai_life/UserScreens/Deals%20Prodduct/todays_deals_product.dart';
import 'package:sai_life/UserScreens/Deals%20Prodduct/trending_deals_product.dart';
import 'package:sai_life/UserScreens/product_details.dart';
import 'package:sai_life/UserScreens/search_product.dart';
import 'package:sai_life/UserScreens/upload_prescreption.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final userDocRef =
      FirebaseFirestore.instance.collection('Sai Life').doc('Details');
  final message =
      "Hello, I need to order medicines and also want to know about the best offers";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SafeArea(
          child: Column(
        children: [
          // Search Area
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
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
                      builder: (context) => const SearchProduct()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Text(
                    'Search medicines & health products',
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
          // Banner Show
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  StreamBuilder(
                      stream: FirebaseData.pharmacybanner(),
                      builder: (BuildContext contex,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          );
                        } else if (snapshot.data!.docs.isEmpty) {
                          return Container();
                        } else {
                          var data = snapshot.data!.docs;
                          return CarouselSlider.builder(
                            itemCount: data.length,
                            itemBuilder: ((context, index, realIndex) {
                              return Container(
                                margin:
                                    const EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      data[index]['Image'],
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            }),
                            options: CarouselOptions(
                              height: 200,
                              aspectRatio: 16 / 9,
                              viewportFraction: 1.0,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.3,
                              scrollDirection: Axis.horizontal,
                            ),
                          );
                        }
                      }),
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 25,
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.only(
                              left: 10, top: 20, right: 10, bottom: 10),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(103, 241, 195, 125),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40.0),
                              bottomRight: Radius.circular(8.0),
                              topLeft: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "UPLOAD A PRESCRIPTION",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "We will arrange your medicine for you",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ))),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const UploadPrescriptionScreen()),
                                  );
                                },
                                child: const Text(
                                  'ORDER NOW',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 25,
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.only(
                              left: 10, top: 20, right: 10, bottom: 10),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(94, 127, 212, 203),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40.0),
                              bottomRight: Radius.circular(8.0),
                              topLeft: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "ORDER VIA WHATSAPP",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "We will call you to confirm your order",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ))),
                                onPressed: () {
                                  sendWhatsAppMessage();
                                },
                                child: const Text(
                                  'CLICK HERE',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder(
                      stream: FirebaseData.getTodaysDeals(),
                      builder: (BuildContext contex,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Column(
                            children: [
                              Container(
                                alignment: Alignment.bottomLeft,
                                margin: const EdgeInsets.only(
                                    top: 20, left: 30, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Today's Deals",
                                      style: GoogleFonts.bebasNeue(
                                          fontSize: 30, color: Colors.black54),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "View All",
                                              style: GoogleFonts.acme(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 17,
                                                  color:
                                                      Colors.deepOrangeAccent),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const TodaysDealsProducts()),
                                                  );
                                                }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 15, right: 15, top: 5),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                        4,
                                        (index) => Container(
                                              width: 170,
                                              height: 290,
                                              margin: const EdgeInsets.all(5),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                            )),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          var data = snapshot.data!.docs;
                          return Column(
                            children: [
                              Container(
                                alignment: Alignment.bottomLeft,
                                margin: const EdgeInsets.only(
                                    top: 20, left: 30, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Today's Deals",
                                      style: GoogleFonts.bebasNeue(
                                          fontSize: 30, color: Colors.black54),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "View All",
                                              style: GoogleFonts.acme(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 17,
                                                  color:
                                                      Colors.deepOrangeAccent),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const TodaysDealsProducts()),
                                                  );
                                                }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 15, right: 15, top: 5),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                        data.length,
                                        (index) => GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetails(
                                                              pname:
                                                                  "${data[index]['P_Name']}",
                                                              data:
                                                                  data[index])),
                                                );
                                              },
                                              child: Container(
                                                width: 170,
                                                margin: const EdgeInsets.all(5),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade200),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    FadeInImage(
                                                      width: 150,
                                                      height: 150,
                                                      placeholder: const AssetImage(
                                                          "assets/logos/product.png"),
                                                      image: NetworkImage(
                                                          data[index]['Image']),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "${data[index]['P_Name']}",
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                                      height: 10,
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
                                            )),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                      stream: FirebaseData.dealbanner(),
                      builder: (BuildContext contex,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          );
                        } else if (snapshot.data!.docs.isEmpty) {
                          return Container();
                        } else {
                          var data = snapshot.data!.docs;
                          return CarouselSlider.builder(
                            itemCount: data.length,
                            itemBuilder: ((context, index, realIndex) {
                              return Container(
                                margin:
                                    const EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      data[index]['Image'],
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            }),
                            options: CarouselOptions(
                              height: 200,
                              aspectRatio: 16 / 9,
                              viewportFraction: 1.0,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.3,
                              scrollDirection: Axis.horizontal,
                            ),
                          );
                        }
                      }),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 248, 231, 182),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.call,
                          size: 60,
                          color: Colors.black54,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "CALL TO ORDER MEDICINE",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ))),
                              onPressed: () => launch('tel: 7757083841'),
                              child: const Text(
                                'CALL NOW',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  StreamBuilder(
                      stream: FirebaseData.getTrendingDeals(),
                      builder: (BuildContext contex,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            color: Colors.blueGrey,
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  margin: const EdgeInsets.only(
                                      top: 20, left: 30, right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Trending Near You",
                                        style: GoogleFonts.alice(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: "View All",
                                                style: GoogleFonts.acme(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize: 17,
                                                    color: Colors.greenAccent),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const TrendingDealsProduct()),
                                                        );
                                                      }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15, top: 5),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(
                                          4,
                                          (index) => Container(
                                                width: 170,
                                                height: 290,
                                                margin: const EdgeInsets.all(5),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0)),
                                              )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          var data = snapshot.data!.docs;
                          return Container(
                            color: Colors.blueGrey,
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  margin: const EdgeInsets.only(
                                      top: 20, left: 30, right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Trending Near You",
                                        style: GoogleFonts.alice(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: "View All",
                                                style: GoogleFonts.acme(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize: 17,
                                                    color: Colors.greenAccent),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {}),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15, top: 5),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(
                                          data.length,
                                          (index) => GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetails(
                                                                pname:
                                                                    "${data[index]['P_Name']}",
                                                                data: data[
                                                                    index])),
                                                  );
                                                },
                                                child: Container(
                                                  width: 170,
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      FadeInImage(
                                                        width: 150,
                                                        height: 150,
                                                        placeholder:
                                                            const AssetImage(
                                                                "assets/logos/product.png"),
                                                        image: NetworkImage(
                                                            data[index]
                                                                ['Image']),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "${data[index]['P_Name']}",
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                        height: 10,
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
                                                                    fontSize:
                                                                        24,
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
                                              )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  void sendWhatsAppMessage() async {
    userDocRef.get().then((doc) async {
      if (doc.exists) {
        final phoneNum = doc.data()!['Mobile'];
        var whatsappUrl = "whatsapp://send?phone=$phoneNum&text=$message";

        if (await canLaunch(whatsappUrl)) {
          await launch(whatsappUrl);
        } else {
          var fallbackUrl = "https://wa.me/$phoneNum?text=$message";
          await launch(fallbackUrl);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Something is wrong, try after sometime.')));
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something is wrong, try again.')));
    });
  }
}
