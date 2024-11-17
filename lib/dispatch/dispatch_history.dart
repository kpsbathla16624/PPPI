import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pppi/theme/appcolors.dart'; // Ensure correct theme import

class ViewDispatchScreen extends StatefulWidget {
  @override
  _ViewDispatchScreenState createState() => _ViewDispatchScreenState();
}

class _ViewDispatchScreenState extends State<ViewDispatchScreen> {
  List<Map<String, dynamic>> dispatchData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataFromFirestore();
  }

  Future<void> _loadDataFromFirestore() async {
    try {
      final dispatch =
          await FirebaseFirestore.instance.collection('dispatch').get();

      setState(() {
        dispatchData = dispatch.docs
            .where((doc) =>
                doc.data()['polythene Type'] != null &&
                doc.data()['print Type'] != null &&
                doc.data()['buyer Name'] != null &&
                doc.data()['number Of Packets'] != null &&
                doc.data()['weights'] != null &&
                doc.data()['polythene Size'] != null &&
                doc.data()['total'] != null &&
                doc.data()['date Time'] != null)
            .map((doc) => doc.data())
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
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        );
      },
    ).toList();
  }

  Widget _buildDataTable(List<Map<String, dynamic>> data, List<String> columns) {
    if (data.isEmpty) {
      return Center(
        child: Text('No data available. Please add data.', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: _buildDataColumns(columns),
          rows: data
              .map(
                (row) => DataRow(
                  cells: columns
                      .map(
                        (column) => DataCell(
                          Text(
                            '${row[column]}',
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

  Widget _buildSection(List<Map<String, dynamic>> data, String title, List<String> columnsOrder) {
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
              title,
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
        title: Text('Dispatch History', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection(dispatchData, 'Dispatch Records', [
              'polythene Type',
              'print Type',
              'buyer Name',
              'number Of Packets',
              'weights',
              'polythene Size',
              'total',
              'date Time'
            ]),
          ],
        ),
      ),
    );
  }
}
