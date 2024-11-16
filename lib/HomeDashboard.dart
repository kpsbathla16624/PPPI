import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pppi/theme/appcolors.dart'; // Assuming you have this file

class ChartData {
  ChartData(this.x, this.y, this.label);
  final String x;
  final double y;
  final String label;
}

class MonthlyData {
  MonthlyData(this.month, this.ppDispatch, this.ldDispatch, this.ppPurchase, this.ldPurchase);
  final DateTime month;
  final double ppDispatch;
  final double ldDispatch;
  final double ppPurchase;
  final double ldPurchase;
}

class HomeDashBoard extends StatefulWidget {
  const HomeDashBoard({Key? key}) : super(key: key);

  @override
  State<HomeDashBoard> createState() => _HomeDashBoardState();
}

class _HomeDashBoardState extends State<HomeDashBoard> {
  late TooltipBehavior _tooltipBehaviorDispatch;
  late TooltipBehavior _tooltipBehaviorPurchase;
  late TooltipBehavior _tooltipBehaviorComparison;
  late TooltipBehavior _tooltipBehaviorYearlyTrend;
  final firestore = FirebaseFirestore.instance;

  double pp = 0;
  double ld = 0;
  double dispatchPP = 0;
  double dispatchLD = 0;
  List<MonthlyData> yearlyData = [];

  Future<void> loadData() async {
    try {
      final now = DateTime.now();
      final currentMonth = DateFormat('MM').format(now);

      // Load current month data
      await _loadCurrentMonthData(currentMonth);

      // Load yearly data
      await _loadYearlyData(now);
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _loadCurrentMonthData(String currentMonth) async {
    // Fetch PP purchases
    final QuerySnapshot ppQuery = await firestore.collection('purchase-pp').get();
    pp = ppQuery.docs
        .where((doc) => _isCurrentMonth(doc['Date Time'] as String?, currentMonth))
        .map<double>((doc) => (doc['quantity'] as num?)?.toDouble() ?? 0.0)
        .fold<double>(0.0, (sum, quantity) => sum + quantity);

    // Fetch LD purchases
    final QuerySnapshot ldQuery = await firestore.collection('purchase-LD').get();
    ld = ldQuery.docs
        .where((doc) => _isCurrentMonth(doc['Date Time'] as String?, currentMonth))
        .map<double>((doc) => (doc['quantity'] as num?)?.toDouble() ?? 0.0)
        .fold(0.0, (sum, quantity) => sum + quantity);

    // Fetch dispatches
    final QuerySnapshot dispatchQuery = await firestore.collection('dispatch').get();

    dispatchPP = dispatchQuery.docs
        .where((doc) => doc['polythene Type'] == 'PP' && _isCurrentMonth(doc['date Time'] as String?, currentMonth))
        .map<double>((doc) => (doc['total'] as num?)?.toDouble() ?? 0.0)
        .fold<double>(0.0, (sum, total) => sum + total);

    dispatchLD = dispatchQuery.docs
        .where((doc) => doc['polythene Type'] == 'LDPE' && _isCurrentMonth(doc['date Time'] as String?, currentMonth))
        .map<double>((doc) => (doc['total'] as num?)?.toDouble() ?? 0.0)
        .fold<double>(0.0, (sum, total) => sum + total);
  }

  Future<void> _loadYearlyData(DateTime now) async {
    yearlyData.clear();

    // Get start of the year
    final startDate = DateTime(now.year, 1, 1);

    for (int month = 1; month <= 12; month++) {
      final currentDate = DateTime(now.year, month, 1);
      if (currentDate.isAfter(now)) break;

      final monthStr = month.toString().padLeft(2, '0');

      // Fetch monthly PP dispatch
      final ppDispatch = await _getMonthlyDispatchTotal('PP', monthStr);
      final ldDispatch = await _getMonthlyDispatchTotal('LDPE', monthStr);
      final ppPurchase = await _getMonthlyPurchaseTotal('purchase-pp', monthStr);
      final ldPurchase = await _getMonthlyPurchaseTotal('purchase-LD', monthStr);

      yearlyData.add(MonthlyData(currentDate, ppDispatch, ldDispatch, ppPurchase, ldPurchase));
    }
  }

  Future<double> _getMonthlyDispatchTotal(String type, String month) async {
    final QuerySnapshot query = await firestore.collection('dispatch').get();
    return query.docs
        .where((doc) => doc['polythene Type'] == type && _isSpecificMonth(doc['date Time'] as String?, month))
        .map<double>((doc) => (doc['total'] as num?)?.toDouble() ?? 0.0)
        .fold<double>(0.0, (sum, total) => sum + total);
  }

  Future<double> _getMonthlyPurchaseTotal(String collection, String month) async {
    final QuerySnapshot query = await firestore.collection(collection).get();
    return query.docs
        .where((doc) => _isSpecificMonth(doc['Date Time'] as String?, month))
        .map<double>((doc) => (doc['quantity'] as num?)?.toDouble() ?? 0.0)
        .fold<double>(0.0, (sum, quantity) => sum + quantity);
  }

  bool _isCurrentMonth(String? dateString, String currentMonth) {
    if (dateString == null || dateString.isEmpty) return false;
    try {
      final timestamp = DateFormat('dd/MM/yyyy, H:mm').parse(dateString);
      return DateFormat('MM').format(timestamp) == currentMonth;
    } catch (e) {
      print('Date parsing error: $e');
      return false;
    }
  }

  bool _isSpecificMonth(String? dateString, String month) {
    if (dateString == null || dateString.isEmpty) return false;
    try {
      final timestamp = DateFormat('dd/MM/yyyy, H:mm').parse(dateString);
      return DateFormat('MM').format(timestamp) == month;
    } catch (e) {
      print('Date parsing error: $e');
      return false;
    }
  }

  Future<void> _refreshData() async {
    await loadData();
    setState(() {});
  }

  @override
  void initState() {
    _tooltipBehaviorDispatch = TooltipBehavior(enable: true);
    _tooltipBehaviorPurchase = TooltipBehavior(enable: true);
    _tooltipBehaviorComparison = TooltipBehavior(enable: true);
    _tooltipBehaviorYearlyTrend = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: FutureBuilder<void>(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<ChartData> dispatchData = [
              ChartData('PP', dispatchPP, 'PP Dispatched: ${dispatchPP.toStringAsFixed(2)}'),
              ChartData('LDPE', dispatchLD, 'LDPE Dispatched: ${dispatchLD.toStringAsFixed(2)}'),
            ];

            final List<ChartData> purchaseData = [
              ChartData('PP', pp, 'PP Purchased: ${pp.toStringAsFixed(2)}'),
              ChartData('LDPE', ld, 'LDPE Purchased: ${ld.toStringAsFixed(2)}'),
            ];

            return Scaffold(
              backgroundColor: AppColors.primaryDark,
              appBar: AppBar(
                title: const Text("Dashboard", style: TextStyle(color: AppColors.textPrimary)),
                backgroundColor: AppColors.secondaryDark,
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.accentColor.withOpacity(0.2), AppColors.cardDark], // Define your gradient colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildChartCard(
                        'Total Orders Dispatched This Month',
                        _buildRadialBarChart(dispatchData, _tooltipBehaviorDispatch),
                      ),
                      const SizedBox(height: 20),
                      _buildChartCard(
                        'Total Purchases This Month',
                        _buildRadialBarChart(purchaseData, _tooltipBehaviorPurchase),
                      ),
                      const SizedBox(height: 20),
                      _buildChartCard(
                        'Monthly Comparison',
                        _buildComparisonChart(dispatchData, purchaseData, _tooltipBehaviorComparison),
                      ),
                      const SizedBox(height: 20),
                      _buildChartCard(
                        'Yearly Trend',
                        _buildYearlyTrendChart(yearlyData, _tooltipBehaviorYearlyTrend),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text("Failed to load data"));
          }
        },
      ),
    );
  }

  Widget _buildChartCard(String title, Widget chart) {
    return SizedBox(
      child: Card(
        color: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              chart,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadialBarChart(List<ChartData> data, TooltipBehavior tooltipBehavior) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: SfCircularChart(
        tooltipBehavior: tooltipBehavior,
        series: <CircularSeries>[
          RadialBarSeries<ChartData, String>(
            dataSource: data,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonChart(List<ChartData> dispatchData, List<ChartData> purchaseData, TooltipBehavior tooltipBehavior) {
    return SfCartesianChart(
      tooltipBehavior: tooltipBehavior,
      primaryXAxis: CategoryAxis(),
      series: <CartesianSeries>[
        ColumnSeries<ChartData, String>(
          name: 'Dispatch',
          dataSource: dispatchData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          color: AppColors.accentColor,
        ),
        ColumnSeries<ChartData, String>(
          name: 'Purchase',
          dataSource: purchaseData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          color: AppColors.textPrimary,
        ),
      ],
    );
  }

  Widget _buildYearlyTrendChart(List<MonthlyData> yearlyData, TooltipBehavior tooltipBehavior) {
    return SfCartesianChart(
      tooltipBehavior: tooltipBehavior,
      primaryXAxis: DateTimeCategoryAxis(),
      series: <CartesianSeries>[
        LineSeries<MonthlyData, DateTime>(
          dataSource: yearlyData,
          xValueMapper: (MonthlyData data, _) => data.month,
          yValueMapper: (MonthlyData data, _) => data.ppDispatch,
          name: 'PP Dispatch',
          color: AppColors.accentColor,
        ),
        LineSeries<MonthlyData, DateTime>(
          dataSource: yearlyData,
          xValueMapper: (MonthlyData data, _) => data.month,
          yValueMapper: (MonthlyData data, _) => data.ldDispatch,
          name: 'LD Dispatch',
          color: AppColors.textPrimary,
        ),
        LineSeries<MonthlyData, DateTime>(
          dataSource: yearlyData,
          xValueMapper: (MonthlyData data, _) => data.month,
          yValueMapper: (MonthlyData data, _) => data.ppPurchase,
          name: 'PP Purchase',
          color: AppColors.primaryDark,
        ),
        LineSeries<MonthlyData, DateTime>(
          dataSource: yearlyData,
          xValueMapper: (MonthlyData data, _) => data.month,
          yValueMapper: (MonthlyData data, _) => data.ldPurchase,
          name: 'LD Purchase',
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}
