import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pppi/theme/appcolors.dart'; // Ensure correct theme import

class ViewCompletedOrdersScreen extends StatefulWidget {
  @override
  _ViewCompletedOrdersScreenState createState() => _ViewCompletedOrdersScreenState();
}

class _ViewCompletedOrdersScreenState extends State<ViewCompletedOrdersScreen> {
  List<Map<String, dynamic>> _completedOrdersPP = [];
  List<Map<String, dynamic>> _completedOrdersLDPE = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompletedOrdersFromFirestore();
  }

  Future<void> _loadCompletedOrdersFromFirestore() async {
    try {
      final completedOrders = await FirebaseFirestore.instance.collection('completed-order').get();

      setState(() {
        _completedOrdersPP = completedOrders.docs.where((doc) => doc.data()['material type'] == 'PP').map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['documentId'] = doc.id;
          return data;
        }).toList();

        _completedOrdersLDPE = completedOrders.docs.where((doc) => doc.data()['material type'] == 'LDPE').map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['documentId'] = doc.id;
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

  List<DataColumn> _buildDataColumns(List<String> columns) {
    return columns.map(
      (column) {
        return DataColumn(
          label: Text(
            '$column',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        );
      },
    ).toList();
  }

  Widget _buildDataTable(List<Map<String, dynamic>> data, List<String> columns) {
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
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSection(List<Map<String, dynamic>> data, List<String> columnsOrder, String name) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

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
              'Completed Orders for $name',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          data.isEmpty
              ? Center(child: Text('No completed orders available for $name', style: TextStyle(color: AppColors.textSecondary)))
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
        title: Text('Completed Orders', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection(
                _completedOrdersPP,
                [
                  'material type',
                  'print type',
                  'Buyer Name',
                  'Quantity',
                  'Size',
                  'Guage',
                  'Date and Time',
                ],
                'PP'),
            SizedBox(height: 16), // Adjust the spacing between sections
            _buildSection(
                _completedOrdersLDPE,
                [
                  'material type',
                  'print type',
                  'Buyer Name',
                  'Quantity',
                  'Size',
                  'Guage',
                  'Date and Time',
                ],
                'LDPE'),
          ],
        ),
      ),
    );
  }
}
