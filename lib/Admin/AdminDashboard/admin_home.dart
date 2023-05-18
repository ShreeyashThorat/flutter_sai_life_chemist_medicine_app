import 'package:flutter/material.dart';
import 'package:sai_life/Admin/AdminAccount/total_users.dart';
import 'package:sai_life/Admin/Discount%20Deals/discount_deals.dart';
import 'package:sai_life/Admin/Orders/delivery_status.dart';
import 'package:sai_life/Admin/Orders/pending_orders.dart';
import 'package:sai_life/Admin/Product/add_product.dart';
import 'package:sai_life/Admin/Product/add_product_img.dart';
import 'package:sai_life/Admin/Upload%20Product/upload_product.dart';
import 'package:sai_life/Admin/Users%20Prescriptions/received_prescription.dart';
import 'package:sai_life/Admin/Withdrawal%20Request/withdrawal_request.dart';
import 'package:sai_life/Database/databasedata.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15, top: 15, right: 15),
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                ),
              ),
              child: const Text(
                'Admin Tools',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15),
              padding: const EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      FutureBuilder<List<String>>(
                          future: getPendingOrder(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                List<String> orderId = snapshot.data!;
                                int pending = orderId.length;
                                return Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PendingOrder()),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    3) -
                                                10.67,
                                        padding: const EdgeInsets.only(
                                            top: 15, bottom: 10),
                                        child: Column(
                                          children: const [
                                            Image(
                                              image: AssetImage(
                                                  'assets/admin/pending.png'),
                                              height: 50,
                                              width: 50,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'Pending',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              'Orders',
                                              style: TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    pending != 0
                                        ? Positioned(
                                            right: 15,
                                            top: 5,
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.deepOrange,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: 30,
                                                minHeight: 14,
                                              ),
                                              child: Text(
                                                pending.toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        : Container()
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error:${snapshot.error}');
                              } else {
                                return const Text('No data');
                              }
                            } else {
                              return Container(
                                width: (MediaQuery.of(context).size.width / 3) -
                                    10.67,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              );
                            }
                          }),
                      FutureBuilder<List<String>>(
                          future: tobeDelivered(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                List<String> orderId = snapshot.data!;
                                int pending = orderId.length;
                                return Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const DeliveryStatus()),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    3) -
                                                10.67,
                                        padding: const EdgeInsets.only(
                                            top: 15, bottom: 10),
                                        child: Column(
                                          children: const [
                                            Image(
                                              image: AssetImage(
                                                  'assets/admin/package.png'),
                                              height: 50,
                                              width: 50,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'To Be',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              'Delivered',
                                              style: TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    pending != 0
                                        ? Positioned(
                                            right: 15,
                                            top: 5,
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.deepOrange,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: 30,
                                                minHeight: 14,
                                              ),
                                              child: Text(
                                                pending.toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        : Container()
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error:${snapshot.error}');
                              } else {
                                return const Text('No data');
                              }
                            } else {
                              return Container(
                                width: (MediaQuery.of(context).size.width / 3) -
                                    10.67,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              );
                            }
                          }),
                      FutureBuilder<List<String>>(
                          future: orderByPrescription(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                List<String> orderId = snapshot.data!;
                                int prescription = orderId.length;
                                return Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ReceivedPrescription()),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    3) -
                                                10.67,
                                        padding: const EdgeInsets.only(
                                            top: 15, bottom: 10),
                                        child: Column(
                                          children: const [
                                            Image(
                                              image: AssetImage(
                                                  'assets/admin/prescription.png'),
                                              height: 50,
                                              width: 50,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'Order by',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              'Prescription',
                                              style: TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    prescription != 0
                                        ? Positioned(
                                            right: 15,
                                            top: 5,
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.deepOrange,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: 30,
                                                minHeight: 14,
                                              ),
                                              child: Text(
                                                prescription.toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        : Container()
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error:${snapshot.error}');
                              } else {
                                return const Text('No data');
                              }
                            } else {
                              return Container(
                                width: (MediaQuery.of(context).size.width / 3) -
                                    10.67,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              );
                            }
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DiscountDeals()),
                          );
                        },
                        child: Container(
                          width:
                              (MediaQuery.of(context).size.width / 3) - 10.67,
                          padding: const EdgeInsets.only(top: 15, bottom: 10),
                          child: Column(
                            children: const [
                              Image(
                                image: AssetImage('assets/admin/discount.png'),
                                height: 50,
                                width: 50,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Discount',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                'Deals',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TotalUsers()),
                          );
                        },
                        child: Container(
                          width:
                              (MediaQuery.of(context).size.width / 3) - 10.67,
                          padding: const EdgeInsets.only(top: 15, bottom: 10),
                          child: Column(
                            children: const [
                              Image(
                                image: AssetImage('assets/admin/group.png'),
                                height: 50,
                                width: 50,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Total',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                'Users',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Select Method"),
                                actions: [
                                  Card(
                                    elevation: 3,
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
                                                BorderRadius.circular(5.0),
                                          ))),
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddProduct()),
                                        ).then((value) =>
                                            Navigator.of(context).pop());
                                      },
                                      child: const Text(
                                        'Use Image Url',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Card(
                                    elevation: 3,
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
                                                BorderRadius.circular(5.0),
                                          ))),
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddProductImg()),
                                        ).then((value) =>
                                            Navigator.of(context).pop());
                                      },
                                      child: const Text(
                                        'Import Image',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          width:
                              (MediaQuery.of(context).size.width / 3) - 10.67,
                          padding: const EdgeInsets.only(top: 15, bottom: 10),
                          child: Column(
                            children: const [
                              Image(
                                image:
                                    AssetImage('assets/admin/addproduct.png'),
                                height: 50,
                                width: 50,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Add',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                'Products',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      FutureBuilder<List<String>>(
                          future: withdrawalRequest(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                List<String> orderId = snapshot.data!;
                                int withdrawal = orderId.length;
                                return Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const WithdrawalRequest()),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    3) -
                                                10.67,
                                        padding: const EdgeInsets.only(
                                            top: 15, bottom: 10),
                                        child: Column(
                                          children: const [
                                            Image(
                                              image: AssetImage(
                                                  'assets/admin/withdraw.png'),
                                              height: 50,
                                              width: 50,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'Withdrawal',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              'Request',
                                              style: TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    withdrawal != 0
                                        ? Positioned(
                                            right: 15,
                                            top: 5,
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.deepOrange,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: 30,
                                                minHeight: 14,
                                              ),
                                              child: Text(
                                                withdrawal.toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        : Container()
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error:${snapshot.error}');
                              } else {
                                return const Text('No data');
                              }
                            } else {
                              return Container(
                                width: (MediaQuery.of(context).size.width / 3) -
                                    10.67,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              );
                            }
                          }),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UploadProductData()),
                          );
                        },
                        child: Container(
                          width:
                              (MediaQuery.of(context).size.width / 3) - 10.67,
                          padding: const EdgeInsets.only(top: 15, bottom: 10),
                          child: Column(
                            children: const [
                              Image(
                                image:
                                    AssetImage('assets/admin/uploadfile.png'),
                                height: 50,
                                width: 50,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Upload',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                'Data',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
