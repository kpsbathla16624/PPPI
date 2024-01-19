import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // Future<void> _loadDataFromFirestore() async {
  //   try {
  //     final purchasePP =
  //         await FirebaseFirestore.instance.collection('dispatch').get();

  //     setState(() {
  //       dispatchData = purchasePP.docs.map((doc) => doc.data()).toList();

  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     print('Error loading data from Firestore: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error loading data from Firestore.'),
  //       ),
  //     );
  //   }
  // }
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
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    ).toList();
  }

  Widget _buildDataTable(
      List<Map<String, dynamic>> data, List<String> columns) {
    if (data.isEmpty) {
      return Center(
        child: Text('No data available. Please add data.'),
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
                          Text('${row[column]}'),
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

  Widget _buildSection(
      List<Map<String, dynamic>> data, List<String> columnsOrder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildDataTable(data, columnsOrder),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('dispatch History'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            _buildSection(dispatchData, [
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
