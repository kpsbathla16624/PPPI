import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pppi/theme/appbartheme.dart';

class ViewInventoryScreen extends StatefulWidget {
  @override
  _ViewInventoryScreenState createState() => _ViewInventoryScreenState();
}

class _ViewInventoryScreenState extends State<ViewInventoryScreen> {
  List<Map<String, dynamic>> _purchasePPData = [];
  List<Map<String, dynamic>> _purchaseLDData = [];
  List<Map<String, dynamic>> _purchaseFilmData = [];
  List<Map<String, dynamic>> _purchaseMouldingData = [];
  List<Map<String, dynamic>> _purchaseInkData = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataFromFirestore();
  }

  Future<void> _loadDataFromFirestore() async {
    try {
      final purchasePP = await FirebaseFirestore.instance.collection('purchase-pp').get();
      final purchaseLD = await FirebaseFirestore.instance.collection('purchase-LD').get();
      final purchaseFilm = await FirebaseFirestore.instance.collection('purchase-Film').get();
      final purchaseMoulding = await FirebaseFirestore.instance.collection('purchase-moulding').get();
      final purchaseInk = await FirebaseFirestore.instance.collection('purchase-ink').get();

      setState(() {
        _purchasePPData = purchasePP.docs
            .where((doc) =>
                doc.data()['material type'] != null &&
                doc.data()['seller Name'] != null &&
                doc.data()['quantity'] != null &&
                doc.data()['Date Time'] != null)
            .map((doc) => doc.data())
            .toList();

        _purchaseLDData = purchaseLD.docs
            .where((doc) =>
                doc.data()['material type'] != null &&
                doc.data()['seller Name'] != null &&
                doc.data()['quantity'] != null &&
                doc.data()['Date Time'] != null)
            .map((doc) => doc.data())
            .toList();

        _purchaseFilmData = purchaseFilm.docs
            .where((doc) =>
                doc.data()['material type'] != null &&
                doc.data()['seller Name'] != null &&
                doc.data()['quantity'] != null &&
                doc.data()['Date Time'] != null)
            .map((doc) => doc.data())
            .toList();

        _purchaseMouldingData = purchaseMoulding.docs
            .where((doc) =>
                doc.data()['material type'] != null &&
                doc.data()['seller Name'] != null &&
                doc.data()['quantity'] != null &&
                doc.data()['Date Time'] != null)
            .map((doc) => doc.data())
            .toList();

        _purchaseInkData = purchaseInk.docs
            .where((doc) =>
                doc.data()['material type'] != null &&
                doc.data()['seller Name'] != null &&
                doc.data()['quantity'] != null &&
                doc.data()['Ink color'] != null &&
                doc.data()['Date Time'] != null)
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

  Widget _buildDataTable(List<Map<String, dynamic>> data, List<String> columns) {
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

  Widget _buildSection(List<Map<String, dynamic>> data, String title, List<String> columnsOrder) {
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
        _isLoading ? Center(child: CircularProgressIndicator()) : _buildDataTable(data, columnsOrder),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 1, 41, 46),
        title: Text('Purchase History' , style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            _buildSection(_purchasePPData, 'Purchase PP', ['material type', 'seller Name', 'quantity', 'Date Time']),
            _buildSection(_purchaseLDData, 'Purchase LD', ['material type', 'seller Name', 'quantity', 'Date Time']),
            _buildSection(_purchaseFilmData, 'Purchase Film', ['material type', 'seller Name', 'quantity', 'Date Time']),
            _buildSection(_purchaseMouldingData, 'Purchase Moulding', ['material type', 'seller Name', 'quantity', 'Date Time']),
            _buildSection(
                _purchaseInkData, 'Purchase Ink', ['material type', 'seller Name', 'quantity', 'Ink color', 'Date Time']),
          ],
        ),
      ),
    );
  }
}
