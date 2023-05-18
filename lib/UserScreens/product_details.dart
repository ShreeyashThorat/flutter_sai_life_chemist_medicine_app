import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_cart/fancy_cart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sai_life/Database/databasedata.dart';
import 'package:sai_life/UserScreens/cart.dart';

final CartNotifier controller = CartNotifier();

class ProductDetails extends StatefulWidget {
  final String? pname;
  final dynamic data;
  const ProductDetails({Key? key, required this.pname, this.data})
      : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int time = 0;

  String mrp = "";
  String sellingPrice = "";

  @override
  void initState() {
    super.initState();
  }

  void getPrices() {
    setState(() {
      mrp = widget.data["Price"];
      sellingPrice = widget.data["S_price"];
    });
  }

  double calculateDiscount() {
    double mrpPrice = double.parse(mrp);
    double selling = double.parse(sellingPrice);

    double discount = mrpPrice - selling;
    double discountPercentage = (discount / mrpPrice) * 100;

    return discountPercentage;
  }

  @override
  Widget build(BuildContext context) {
    double price;
    price = double.tryParse((widget.data["S_price"]).toString())!;

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
            'SAi LiFE CHEMiST',
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3,
                      child: FadeInImage(
                          placeholder:
                              const AssetImage("assets/logos/product.png"),
                          image: NetworkImage(widget.data["Image"])),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.pname!,
                      style: GoogleFonts.andika(
                          fontSize: 22,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      widget.data["DrugCategory"],
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "MRP \u{20B9}${widget.data["Price"]}",
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 18,
                          color: Colors.grey),
                    ),
                    Row(
                      children: [
                        Text(
                          "\u{20B9}${widget.data["S_price"]}",
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "(${(((widget.data["Price"] - widget.data["S_price"]) / widget.data["Price"]) * 100).toStringAsFixed(2)}%)",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.deepOrange),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "Not Refundable",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    AddToCartButton(
                      actionAfterAdding: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Cart()),
                            (Route<dynamic> route) => false);
                        setState(() {
                          time = DateTime.now().millisecondsSinceEpoch;
                        });
                      },
                      cartModel: CartItem(
                          id: time,
                          name: widget.pname!,
                          price: price,
                          image: widget.data["Image"]),
                      child: Container(
                        height: 40,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                          child: Text(
                            'ADD TO CART',
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Today's Deals",
                                        style: GoogleFonts.bebasNeue(
                                            fontSize: 30,
                                            color: Colors.black54),
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
                                                    color: Colors
                                                        .deepOrangeAccent),
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
                                          4,
                                          (index) => Container(
                                                width: 170,
                                                height: 290,
                                                margin: const EdgeInsets.all(5),
                                                padding:
                                                    const EdgeInsets.all(10),
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Today's Deals",
                                        style: GoogleFonts.bebasNeue(
                                            fontSize: 30,
                                            color: Colors.black54),
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
                                                    color: Colors
                                                        .deepOrangeAccent),
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
                                CarouselSlider.builder(
                                  itemCount: data.length,
                                  itemBuilder: ((context, index, realIndex) {
                                    return GestureDetector(
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
                                      child: Container(
                                        width: 170,
                                        margin: const EdgeInsets.all(5),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade200),
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
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
                                                  fontWeight: FontWeight.bold),
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
                                                  style: GoogleFonts.bebasNeue(
                                                      fontSize: 24,
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "(${(((data[index]['Price'] - data[index]['S_price']) / data[index]['Price']) * 100).toStringAsFixed(2)}%)",
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.deepOrange),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                  options: CarouselOptions(
                                    height: 300,
                                    aspectRatio: 16 / 9,
                                    viewportFraction: 0.5,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: true,
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    autoPlayAnimationDuration:
                                        const Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    enlargeFactor: 0.0,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                              ],
                            );
                          }
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    StreamBuilder(
                        stream: FirebaseData.getTrendingDeals(),
                        builder: (BuildContext contex,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Column(
                              children: [
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Trending Near You",
                                        style: GoogleFonts.bebasNeue(
                                            fontSize: 30,
                                            color: Colors.black54),
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
                                                    color: Colors
                                                        .deepOrangeAccent),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {}),
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
                                                padding:
                                                    const EdgeInsets.all(10),
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Trending Near You",
                                        style: GoogleFonts.bebasNeue(
                                            fontSize: 30,
                                            color: Colors.black54),
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
                                                    color: Colors
                                                        .deepOrangeAccent),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {}),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CarouselSlider.builder(
                                  itemCount: data.length,
                                  itemBuilder: ((context, index, realIndex) {
                                    return GestureDetector(
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
                                      child: Container(
                                        width: 170,
                                        margin: const EdgeInsets.all(5),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade200),
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
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
                                                  fontWeight: FontWeight.bold),
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
                                                  style: GoogleFonts.bebasNeue(
                                                      fontSize: 24,
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "(${(((data[index]['Price'] - data[index]['S_price']) / data[index]['Price']) * 100).toStringAsFixed(2)}%)",
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.deepOrange),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                  options: CarouselOptions(
                                    height: 300,
                                    aspectRatio: 16 / 9,
                                    viewportFraction: 0.5,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: true,
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    autoPlayAnimationDuration:
                                        const Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    enlargeFactor: 0.0,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                              ],
                            );
                          }
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Product Description",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.data["Description"],
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Product Ingredients",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.data["Ingredients"],
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            )),
          ],
        ));
  }
}
