// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_cart/fancy_cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sai_life/UserScreens/select_address.dart';
import 'package:sai_life/screens/dashboard.dart';
import 'package:sai_life/screens/register_user.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
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
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Dashboard()),
                  )),
          title: const Text(
            'SAi LiFE CHEMiST',
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: CartWidget(cartBuilder: (controller) {
          if (controller.cartList.isEmpty) {
            return Center(
              child: Text(
                "Oops...Cart is Empty",
                style: GoogleFonts.righteous(
                    fontSize: 30, color: Colors.teal.shade700),
              ),
            );
          } else {
            return Container(
              margin: const EdgeInsets.only(right: 2),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.cartList.length,
                      itemBuilder: (context, index) {
                        final cartItem = controller.cartList[index];
                        return Slidable(
                          key: Key("$cartItem"),
                          endActionPane: ActionPane(
                              extentRatio: 0.15,
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    controller.removeItem(cartItem);
                                  },
                                  backgroundColor: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                  icon: Icons.delete,
                                )
                              ]),
                          child: Card(
                            elevation: 1,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                children: [
                                  Image.network(
                                    cartItem.image,
                                    width: 100,
                                    height: 100,
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                    height: 100,
                                    padding: const EdgeInsets.only(top: 20),
                                    width:
                                        MediaQuery.of(context).size.width - 180,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartItem.name,
                                          maxLines: 2,
                                          style: GoogleFonts.akshar(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "\u{20B9} ${controller.getPriceForItem(cartItem, updatePrice: true).toStringAsFixed(2)}",
                                          style: GoogleFonts.bebasNeue(
                                              fontSize: 24,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Column(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            controller.incrementItemQuantity(
                                                cartItem);
                                          },
                                          icon: const Icon(Icons.add),
                                        ),
                                        Text(cartItem.quantity.toString()),
                                        IconButton(
                                          onPressed: () {
                                            controller.decrementItemQuantity(
                                                cartItem);
                                          },
                                          icon: const Icon(Icons.remove),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 15),
                      width: MediaQuery.of(context).size.width,
                      child: const Text("Swipe left to remove item*")),
                  // ----------------- Total Price in Cart ----------------- //
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bill Summary",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Cart Value",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
                            Text(
                              "\u{20B9} ${controller.getTotalPrice().toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Delivery Charges",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
                            Text(
                              "\u{20B9} 40",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.grey.shade200,
                          height: 2,
                          width: MediaQuery.of(context).size.width,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "\u{20B9} ${(controller.getTotalPrice() + 40).toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          color: Colors.grey.shade200,
                          height: 2,
                          width: MediaQuery.of(context).size.width,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "To be paid",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "\u{20B9} ${(controller.getTotalPrice() + 40).toStringAsFixed(0)}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.teal.shade700),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ))),
                      onPressed: () async {
                        String contact = FirebaseAuth
                            .instance.currentUser!.phoneNumber
                            .toString();
                        Future<bool> userExists(contact) async {
                          return await FirebaseFirestore.instance
                              .collection('Users')
                              .where('Phone No', isEqualTo: contact)
                              .get()
                              .then((value) => value.size > 0 ? true : false);
                        }

                        bool result = await userExists(contact);
                        if (result == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SelectAddress()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterUser()),
                          );
                        }
                      },
                      child: const Text(
                        'PLACE ORDER',
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }));
  }
}
