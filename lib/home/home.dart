import 'package:flutter/material.dart';
import 'package:pppi/circular_chart.dart';
import 'package:pppi/drawers/daybook.dart';
import 'package:pppi/drawers/dispatch.dart';
import 'package:pppi/drawers/order.dart';
import 'package:pppi/drawers/purchase.dart';
import 'package:pppi/orders/stock.dart';
import 'package:pppi/employee/emp.dart';

class home extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int _selectedIndex = 0;

  Widget _body = Scaffold(); // Placeholder widget as initial body

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Update the body based on the selected index

      _updateBody();
    });
  }

  @override
  void initState() {
    updateStock();
    super.initState();

    _onItemTapped(0);

    // Avoid doing asynchronous operations in initState
  }

  // Update the body widget based on the selected index
  void _updateBody() {
    updateStock();
    switch (_selectedIndex) {
      case 0:
        _body = circular_chart();
        //const Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text(
        //       'WELCOME',
        //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
        //     ),
        //     Center(
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Text('click on '),
        //           Icon(Icons.menu),
        //           Text('to continue')
        //         ],
        //       ),
        //     )
        //   ],
        // );

        break;
      case 1:
        _body = PurchaseDrawer(); // Use the PurchaseDrawer widget directly
        break;
      case 2:
        _body = dispatchdrawer();
        break;
      case 3:
        _body = orderDrawer();
        break;
      case 4:
        _body = daybookDrawer();
        break;
      case 5:
        _body = EmployeeDrawer();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 41, 46),
        title: Text(
          'Parmarth Print Pack Industry',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _body,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(color: Colors.greenAccent),
                child: Column(
                  children: [
                    Text(
                      'Parmarth Print Pack industry ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 25),
                    ),
                  ],
                )),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.home),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Home',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                widget.scaffoldKey.currentState?.openEndDrawer();
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.add_shopping_cart_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Purchase',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                widget.scaffoldKey.currentState?.openEndDrawer();
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Image.asset(
                    'assets/dispatch-icon.jpg',
                    height: 26,
                    width: 26,
                  ),
                  const SizedBox(width: 10),
                  const Text('Dispatch',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                widget.scaffoldKey.currentState?.openEndDrawer();
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.add_task_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Order',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3);
                widget.scaffoldKey.currentState?.openEndDrawer();
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.note_add),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Daybook',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
              selected: _selectedIndex == 4,
              onTap: () {
                _onItemTapped(4);
                widget.scaffoldKey.currentState?.openEndDrawer();
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Employees',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
              selected: _selectedIndex == 5,
              onTap: () {
                _onItemTapped(4);
                widget.scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ],
        ),
      ),
    );
  }
}
