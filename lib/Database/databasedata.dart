import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseData {
  static getUser(uid) {
    return FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .snapshots();
  }

  static totalUsers() {
    return FirebaseFirestore.instance.collection('Users').snapshots();
  }

  static getProducts() {
    return FirebaseFirestore.instance.collection('Products').snapshots();
  }

  static getTodaysDeals() {
    return FirebaseFirestore.instance
        .collection('Products')
        .where("Todays Deals", isEqualTo: true)
        .snapshots();
  }

  static getTrendingDeals() {
    return FirebaseFirestore.instance
        .collection('Products')
        .where("Treading Near You", isEqualTo: true)
        .snapshots();
  }

  static getSearchProducts(name) {
    return FirebaseFirestore.instance
        .collection('Products')
        .where("P_Name", isEqualTo: name)
        .snapshots();
  }

  static getAddress(uid) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Address')
        .snapshots();
  }

  static getBanks(uid) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Bank Details')
        .snapshots();
  }

  static getTransactions(uid) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Wallet')
        .orderBy('Date', descending: true)
        .snapshots();
  }

  static myWithdrawals(uid) {
    return FirebaseFirestore.instance
        .collection('Withdrawals')
        .where('User', isEqualTo: uid)
        .where('Pending', isEqualTo: true)
        .where('Processed', isEqualTo: false)
        .snapshots();
  }

  static getpendngOrder(id) {
    return FirebaseFirestore.instance
        .collection('Orders')
        .where('Id', isEqualTo: id)
        .snapshots();
  }

  static getPrescriptions(id) {
    return FirebaseFirestore.instance
        .collection('Prescriptions')
        .where('Id', isEqualTo: id)
        .snapshots();
  }

  static getWithdrawalRequest(id) {
    return FirebaseFirestore.instance
        .collection('Withdrawals')
        .where('Id', isEqualTo: id)
        .snapshots();
  }

  static pharmacybanner() {
    return FirebaseFirestore.instance
        .collection('Pharmacy Banners')
        .snapshots();
  }

  static dealbanner() {
    return FirebaseFirestore.instance.collection('Deal Banners').snapshots();
  }
}

Future<List<String>> myPrescriptions(uid) async {
  List<String> orderId = [];

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Prescriptions')
      .where('C_uid', isEqualTo: uid)
      .orderBy('Date', descending: true)
      .get();

  // ignore: avoid_function_literals_in_foreach_calls
  snapshot.docs.forEach((doc) {
    String id = doc.get('Id');
    orderId.add(id);
  });

  return orderId;
}

Future<List<String>> myOrder(uid) async {
  List<String> orderId = [];

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Orders')
      .where('C_uid', isEqualTo: uid)
      .orderBy('Date', descending: true)
      .get();

  // ignore: avoid_function_literals_in_foreach_calls
  snapshot.docs.forEach((doc) {
    String id = doc.get('Id');
    orderId.add(id);
  });

  return orderId;
}

Future<List<String>> getOrder(uid) async {
  List<String> orderId = [];

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Orders')
      .where('C_uid', isEqualTo: uid)
      .where('order_placed', isEqualTo: true)
      .where('Rejected', isEqualTo: false)
      .where('Delivered', isEqualTo: false)
      .get();

  // ignore: avoid_function_literals_in_foreach_calls
  snapshot.docs.forEach((doc) {
    String id = doc.get('Id');
    orderId.add(id);
  });

  return orderId;
}

Future<List<String>> getPendingOrder() async {
  List<String> orderId = [];

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Orders')
      .where('order_placed', isEqualTo: true)
      .where('Rejected', isEqualTo: false)
      .where('Confirmed', isEqualTo: false)
      .get();

  // ignore: avoid_function_literals_in_foreach_calls
  snapshot.docs.forEach((doc) {
    String id = doc.get('Id');
    orderId.add(id);
  });

  return orderId;
}

Future<void> addProduct(String name, String category, num price, String image,
    String description, String ingredients, num sPrice) async {
  try {
    await FirebaseFirestore.instance.collection('Products').add({
      'P_Name': name,
      'DrugCategory': category,
      'Price': price,
      'Image': image,
      'Description': description,
      'Ingredients': ingredients,
      'S_price': sPrice
    });
  } catch (e) {
    debugPrint('Error adding product: $e');
  }
}

Future<List<String>> tobeDelivered() async {
  List<String> orderId = [];

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Orders')
      .where('Confirmed', isEqualTo: true)
      .where('Delivered', isEqualTo: false)
      .get();

  // ignore: avoid_function_literals_in_foreach_calls
  snapshot.docs.forEach((doc) {
    String id = doc.get('Id');
    orderId.add(id);
  });

  return orderId;
}

Future<List<String>> allOrder() async {
  List<String> orderId = [];

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Orders')
      .orderBy('Date', descending: true)
      .get();

  // ignore: avoid_function_literals_in_foreach_calls
  snapshot.docs.forEach((doc) {
    String id = doc.get('Id');
    orderId.add(id);
  });

  return orderId;
}

Future<List<String>> orderByPrescription() async {
  List<String> orderId = [];

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Prescriptions')
      .where('Rejected', isEqualTo: false)
      .where('Confirmed', isEqualTo: false)
      .get();

  // ignore: avoid_function_literals_in_foreach_calls
  snapshot.docs.forEach((doc) {
    String id = doc.get('Id');
    orderId.add(id);
  });

  return orderId;
}

Future<List<String>> withdrawalRequest() async {
  List<String> id = [];

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Withdrawals')
      .where('Processed', isEqualTo: false)
      .get();

  // ignore: avoid_function_literals_in_foreach_calls
  snapshot.docs.forEach((doc) {
    String getId = doc.get('Id');
    id.add(getId);
  });

  return id;
}
