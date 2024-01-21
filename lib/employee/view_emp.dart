import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewEMPScreen extends StatefulWidget {
  @override
  _ViewEMPScreenState createState() => _ViewEMPScreenState();
}

class _ViewEMPScreenState extends State<ViewEMPScreen> {
  List<Map<String, dynamic>> PermanentEMP = [];
  List<Map<String, dynamic>> TemporaryEMP = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataFromFirestore();
  }

  Future<void> _loadDataFromFirestore() async {
    try {
      final permanentEMP =
          await FirebaseFirestore.instance.collection('purchase-pp').get();
      final temporaryEMP =
          await FirebaseFirestore.instance.collection('purchase-LD').get();

      setState(() {
        PermanentEMP = permanentEMP.docs
            .where((doc) =>
                doc.data()['Employee Name'] != null &&
                doc.data()['Salary'] != null &&
                doc.data()['type'] != null &&
                doc.data()['type'] != 'Temporary' &&
                doc.data()['date'] != null)
            .map((doc) => doc.data())
            .toList();
        TemporaryEMP = temporaryEMP.docs
            .where((doc) =>
                doc.data()['Employee Name'] != null &&
                doc.data()['Salary'] != null &&
                doc.data()['type'] != null &&
                doc.data()['type'] != 'Permanent' &&
                doc.data()['date'] != null)
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

  Widget _buildSection(List<Map<String, dynamic>> data, String title,
      List<String> columnsOrder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
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
        title: Text('Purchase History'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            _buildSection(PermanentEMP, 'Permanent employees',
                ['Employee Name', 'Salary', 'type', 'date']),
            _buildSection(TemporaryEMP, 'Temporary employees',
                ['Employee Name', 'Salary', 'type', 'date']),
          ],
        ),
      ),
    );
  }
}
