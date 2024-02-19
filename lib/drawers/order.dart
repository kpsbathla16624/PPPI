import 'package:flutter/material.dart';
import 'package:pppi/orders/add_order.dart';
import 'package:pppi/home/home.dart';
import 'package:pppi/orders/orders-PP.dart';
import 'package:pppi/orders/orders-LD.dart';
import 'package:pppi/orders/completd_order.dart';
import 'package:pppi/orders/stockscreen.dart';

class orderDrawer extends StatefulWidget {
  const orderDrawer({super.key});

  @override
  State<orderDrawer> createState() => _orderDrawerState();
}

class _orderDrawerState extends State<orderDrawer> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => home(),
        ));
      },
      child: Scaffold(
        appBar:  AppBar(
          leading: Icon(
            Icons.post_add_rounded,
            color: Colors.white,
          ),
          title: Text(
            'Order Management',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 1, 41, 46),
          centerTitle: false,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              color: Colors.blue[400],
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Add_order()));
                },
                leading: const Icon(
                  Icons.add_chart_outlined,
                  size: 60,
                  color: Colors.black,
                ),
                title: const Text(
                  'Add Orders',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 27,
                  ),
                ),
                subtitle: const Text(
                  'orders for PP,LD',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              color: Colors.blue[400],
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewOrderLDhistoryScreen()));
                },
                leading: const Icon(
                  Icons.production_quantity_limits,
                  size: 60,
                  color: Colors.black,
                ),
                title: const Text(
                  'Pending Orders - LDPE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 27,
                  ),
                ),
                subtitle: const Text(
                  'view pending Ld orders',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              color: Colors.blue[400],
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewOrderPPhistoryScreen()));
                },
                leading: const Icon(
                  Icons.production_quantity_limits,
                  size: 60,
                  color: Colors.black,
                ),
                title: const Text(
                  'Pending Orders - PP',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 27,
                  ),
                ),
                subtitle: const Text(
                  'view pending PP orders',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              color: Colors.blue[400],
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewCompletedOrdersScreen()));
                },
                leading: const Icon(
                  Icons.add_task_sharp,
                  size: 60,
                  color: Colors.black,
                ),
                title: const Text(
                  'Completed orders',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 27,
                  ),
                ),
                subtitle: const Text(
                  'view completed  orders',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              color: Colors.blue[400],
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StockScreen()));
                },
                leading: const Icon(
                  Icons.stacked_bar_chart,
                  size: 60,
                  color: Colors.black,
                ),
                title: const Text(
                  'View Material Stocks',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 27,
                  ),
                ),
                subtitle: const Text(
                  'view available raw materials ',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
