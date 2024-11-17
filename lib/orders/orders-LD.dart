import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pppi/orders/stock.dart';
import 'package:pppi/theme/appcolors.dart'; // Ensure correct theme import

class ViewOrderLDhistoryScreen extends StatefulWidget {
  @override
  _ViewOrderLDhistoryScreenState createState() =>
      _ViewOrderLDhistoryScreenState();
}

class _ViewOrderLDhistoryScreenState extends State<ViewOrderLDhistoryScreen> {
  List<Map<String, dynamic>> _OrderLDData = [];
  Set<int> _selectedRows = Set<int>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataFromFirestore();
  }

  Future<void> _loadDataFromFirestore() async {
    try {
      final orderLD =
          await FirebaseFirestore.instance.collection('order-LD').get();

      setState(() {
        _OrderLDData = orderLD.docs
            .map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              data['documentId'] = doc.id;
              return data;
            })
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data from Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data from Firestore.'),
        ),
      );
    }
  }

  List<DataColumn> _buildDataColumns(List<String> columns) {
    return columns.map(
      (column) {
        return DataColumn(
          label: Text(
            '$column',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary, // Consistent color
            ),
          ),
        );
      },
    ).toList();
  }

  Widget _buildDataTable(
      List<Map<String, dynamic>> data, List<String> columns) {
    if (data.isEmpty) {
      return Center(
        child: Text('No data available. Please add data.',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: _buildDataColumns(columns),
          rows: data
              .asMap()
              .entries
              .map(
                (entry) => DataRow(
                  cells: columns
                      .map(
                        (column) => DataCell(
                          Text(
                            '${entry.value[column]}',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                        ),
                      )
                      .toList(),
                  selected: _selectedRows.contains(entry.key),
                  onSelectChanged: (isSelected) {
                    setState(() {
                      if (isSelected!) {
                        _selectedRows.add(entry.key);
                      } else {
                        _selectedRows.remove(entry.key);
                      }
                    });
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSection(List<Map<String, dynamic>> data, List<String> columnsOrder) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Order LD History',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _buildDataTable(data, columnsOrder),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryDark,
        title: Text('Order LD', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection(
                _OrderLDData,
                [
                  'material type',
                  'print type',
                  'Buyer Name',
                  'Quantity',
                  'Size',
                  'Guage',
                  'Date and Time',
                ]),
          ],
        ),
      ),
      floatingActionButton: _selectedRows.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                _moveSelectedDocuments();
              },
              child: Icon(Icons.check),
            )
          : null,
    );
  }

  void _moveSelectedDocuments() async {
    for (int index in _selectedRows) {
      String documentId = _OrderLDData[index]['documentId'];
      double quantity = _OrderLDData[index]['Quantity'];

      // Save the selected document to the 'completed-order' collection
      await FirebaseFirestore.instance.collection('completed-order').add(
            _OrderLDData[index],
          );

      // Subtract the quantity from the 'order-PP' field in the 'stock' collection
      await FirebaseFirestore.instance
          .collection('stock')
          .doc('wUNr03PFWTAx36YXldFy')
          .update({
        'order-LD': FieldValue.increment(-quantity),
      });

      // Subtract the quantity from the 'stock-PP' field in the 'stock' collection
      await FirebaseFirestore.instance
          .collection('stock')
          .doc('wUNr03PFWTAx36YXldFy')
          .update({
        'stock-LD': FieldValue.increment(-quantity),
      });

      // Delete the selected document from the 'order-pp' collection
      await FirebaseFirestore.instance
          .collection('order-LD')
          .doc(documentId)
          .delete();

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ViewOrderLDhistoryScreen(),
      ));
      updateStock();
    }

    setState(() {
      _selectedRows.clear();
    });
  }
}
