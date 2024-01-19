import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:pppi/main.dart';

Future<void> updateStock() async {
  order_PP = 0;
  order_LD = 0;
  Stock_PP = 0;
  Stock_LD = 0;

  try {
    final firestore = FirebaseFirestore.instance;

    Future<void> updateStockFromStockCollection() async {
      QuerySnapshot query = await firestore.collection('stock').get();
      for (final doc in query.docs) {
        Stock_PP = doc['stock-PP'] as double? ?? 0;
        Stock_LD = doc['stock-LD'] as double? ?? 0;
        order_PP = doc['order-PP'] as double? ?? 0;

        order_LD = doc['order-LD'] as double? ?? 0;
      }
    }

    // Update stock values from 'stock' collection
    await updateStockFromStockCollection();
  } catch (e) {
    print('Error updating stock: $e');
  }
}
