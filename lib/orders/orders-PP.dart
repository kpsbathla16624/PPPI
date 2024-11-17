import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pppi/theme/appcolors.dart'; // Ensure correct theme import

class ViewOrderPPhistoryScreen extends StatefulWidget {
  @override
  _ViewOrderPPhistoryScreenState createState() =>
      _ViewOrderPPhistoryScreenState();
}

class _ViewOrderPPhistoryScreenState extends State<ViewOrderPPhistoryScreen> {
  List<Map<String, dynamic>> _OrderPPData = [];
  Set<int> _selectedRows = Set<int>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataFromFirestore();
  }

  // Load data from Firestore
  Future<void> _loadDataFromFirestore() async {
    try {
      final orderPP = await FirebaseFirestore.instance.collection('order-pp').get();

      setState(() {
        _OrderPPData = orderPP.docs
            .map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['documentId'] = doc.id; // Add the documentId for deletion
          return data;
        }).toList();
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

  // Build columns for the DataTable
  List<DataColumn> _buildDataColumns(List<String> columns) {
    return columns.map(
      (column) {
        return DataColumn(
          label: Text(
            '$column',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        );
      },
    ).toList();
  }

  // Build the data table with the fetched data
  Widget _buildDataTable(List<Map<String, dynamic>> data, List<String> columns) {
    if (data.isEmpty) {
      return Center(
        child: Text('No data available. Please add data.', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
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
                        Text('${entry.value[column]}', style: TextStyle(color: AppColors.textPrimary)),
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
    );
  }

  // Build section with the data table or loading spinner
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
              'Order - PP Records',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
          _isLoading ? Center(child: CircularProgressIndicator()) : _buildDataTable(data, columnsOrder),
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
        title: Text('Order - PP', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection(_OrderPPData, [
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

  // Move selected documents to the 'completed-order' collection and update stock
  void _moveSelectedDocuments() async {
    for (int index in _selectedRows) {
      String documentId = _OrderPPData[index]['documentId'];
      double quantity = _OrderPPData[index]['Quantity'];

      // Save the selected document to the 'completed-order' collection
      await FirebaseFirestore.instance.collection('completed-order').add(
        _OrderPPData[index],
      );

      // Subtract the quantity from the 'order-PP' field in the 'stock' collection
      await FirebaseFirestore.instance
          .collection('stock')
          .doc('wUNr03PFWTAx36YXldFy')
          .update({
        'order-PP': FieldValue.increment(-quantity),
      });

      // Subtract the quantity from the 'stock-PP' field in the 'stock' collection
      await FirebaseFirestore.instance
          .collection('stock')
          .doc('wUNr03PFWTAx36YXldFy')
          .update({
        'stock-PP': FieldValue.increment(-quantity),
      });

      // Delete the selected document from the 'order-pp' collection
      await FirebaseFirestore.instance
          .collection('order-pp')
          .doc(documentId)
          .delete();

      // Reload the page after update
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ViewOrderPPhistoryScreen(),
      ));
    }

    setState(() {
      _selectedRows.clear();
    });
  }
}
