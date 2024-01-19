import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DaybookHistoryScreen extends StatefulWidget {
  @override
  _DaybookHistoryScreenState createState() => _DaybookHistoryScreenState();
}

class _DaybookHistoryScreenState extends State<DaybookHistoryScreen> {
  // Define the desired order of columns
  List<String> columnOrder = ['description', 'amount', 'Date and time'];

  Future<List<Map<String, dynamic>>> _loadDaybookData() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('daybook').get();

      return querySnapshot.docs
          .map((doc) => {
                'date': doc.id,
                'expenses': doc.reference.collection('expenses').get(),
              })
          .toList();
    } catch (e) {
      print('Error loading daybook data from Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading daybook data from Firestore.'),
        ),
      );

      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daybook History'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _loadDaybookData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            List<Map<String, dynamic>> daybookData = snapshot.data ?? [];

            return Column(
              children: daybookData.map((entry) {
                return _buildDaybookEntry(entry);
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDaybookEntry(Map<String, dynamic> entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Date: ${entry['date']}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        _buildExpensesList(entry['expenses']),
      ],
    );
  }

  Widget _buildExpensesList(Future<QuerySnapshot> expenses) {
    return FutureBuilder<QuerySnapshot>(
      future: expenses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        List<Map<String, dynamic>> expenseData = snapshot.data?.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList() ??
            [];

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              columns: _buildDataColumns(expenseData),
              rows: _buildDataRows(expenseData),
            ),
          ),
        );
      },
    );
  }

  List<DataColumn> _buildDataColumns(List<Map<String, dynamic>> expenseData) {
    return columnOrder.map((column) {
      return DataColumn(
        label: Text(
          '$column',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }).toList();
  }

  List<DataRow> _buildDataRows(List<Map<String, dynamic>> expenseData) {
    return expenseData.map((expense) {
      return DataRow(
        cells: _buildDataCells(expense),
      );
    }).toList();
  }

  List<DataCell> _buildDataCells(Map<String, dynamic> expense) {
    return columnOrder.map((key) {
      return DataCell(
        Text(key == 'Date and time'
            ? '${expense[key] ?? "N/A"}'
            : '${expense[key]}'),
      );
    }).toList();
  }
}
