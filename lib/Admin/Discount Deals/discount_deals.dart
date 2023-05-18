import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:sai_life/Admin/Discount%20Deals/todays_deals.dart';
import 'package:sai_life/Admin/Discount%20Deals/trending_deals.dart';

class DiscountDeals extends StatefulWidget {
  const DiscountDeals({super.key});

  @override
  State<DiscountDeals> createState() => _DiscountDealsState();
}

class _DiscountDealsState extends State<DiscountDeals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 18,
            ),
            onTap: () => Navigator.of(context).pop()),
        title: const Text(
          'Discount Deals',
          style: TextStyle(color: Colors.black, fontSize: 23),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: ContainedTabBarView(
        tabs: const [
          Text('Todays Deals'),
          Text('Trending'),
        ],
        tabBarProperties: const TabBarProperties(
          height: 32.0,
          indicatorColor: Colors.teal,
          indicatorWeight: 2,
          labelColor: Colors.black,
          labelStyle: TextStyle(fontSize: 17),
          unselectedLabelColor: Colors.black54,
        ),
        views: const [
          TodaysDeals(),
          Trending(),
        ],
      ),
    );
  }
}
