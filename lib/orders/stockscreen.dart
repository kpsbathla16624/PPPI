import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pppi/orders/stock.dart';
import 'package:pppi/main.dart';

class StockScreen extends StatefulWidget {
  @override
  StockScreenState createState() => StockScreenState();
}

class StockScreenState extends State<StockScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Stocks();
  }

  Future<void> Stocks() async {
    await updateStock();
    setState(() {
      isLoading = false;
    });
  }

  // Function to set stock values to zero
  Future<void> setStockToZero(String stockType) async {
    // Assuming 'stock' is the collection name
    await FirebaseFirestore.instance
        .collection('stock')
        .doc('wUNr03PFWTAx36YXldFy')
        .update({
      stockType: 0, // Set the specified stock type to zero
    });

    // Refresh the stock values
    await updateStock();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Screen'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Stock PP: $Stock_PP' + ' KG',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          await setStockToZero('stock-PP');
                        },
                        child: Text('All Used'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Stock LD: $Stock_LD' + ' KG',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          await setStockToZero('stock-LD');
                        },
                        child: Text('All Used'),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'PP order pending  : $order_PP' + 'KG',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'LD order pending  : $order_LD' + 'KG',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
    );
  }
}
