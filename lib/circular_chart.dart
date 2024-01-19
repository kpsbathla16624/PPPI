import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'chart_data.dart';

import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class circular_chart extends StatefulWidget {
  const circular_chart({Key? key}) : super(key: key);

  @override
  State<circular_chart> createState() => _circular_chartState();
}

class _circular_chartState extends State<circular_chart> {
  late TooltipBehavior _tooltipBehavior;
  late TooltipBehavior _tooltipBehavior2;
  final firestore = FirebaseFirestore.instance;

  double pp = 0;
  double ld = 0;
  double dispatch_pp = 0;
  double dispatch_LD = 0;

  Future<void> load_DAta() async {
    try {
      final now = DateTime.now();
      final currentMonth = DateFormat('MM').format(now);

      final QuerySnapshot ppQuery =
          await firestore.collection('purchase-pp').get();

      // Calculate sum of quantity for the current month from 'purchase-PP' collection
      pp = ppQuery.docs
          .where((doc) {
            final dateString = doc['Date Time'] as String?;
            if (dateString != null && dateString.isNotEmpty) {
              final timestamp =
                  DateFormat('dd/MM/yyyy, H:mm').parse(dateString);
              return DateFormat('MM').format(timestamp) == currentMonth;
            }
            return false;
          })
          .map<double>((doc) => (doc['quantity'] as num?)?.toDouble() ?? 0)
          .fold(0, (sum, quantity) => sum + quantity);

      final QuerySnapshot ldQuery =
          await firestore.collection('purchase-LD').get();

      // Calculate sum of quantity for the current month from 'purchase-LD' collection
      ld = ldQuery.docs
          .where((doc) {
            final dateString = doc['Date Time'] as String?;
            if (dateString != null && dateString.isNotEmpty) {
              final timestamp =
                  DateFormat('dd/MM/yyyy, H:mm').parse(dateString);
              return DateFormat('MM').format(timestamp) == currentMonth;
            }
            return false;
          })
          .map<double>((doc) => (doc['quantity'] as num?)?.toDouble() ?? 0)
          .fold(0, (sum, quantity) => sum + quantity);
// Load values for dispatch_pp from 'dispatch' collection
      final QuerySnapshot dispatchPPQuery =
          await firestore.collection('dispatch').get();

      dispatch_pp = dispatchPPQuery.docs.where((doc) {
        final polytheneType = doc['polythene Type'] as String?;
        final dateString = doc['date Time'] as String?;
        if (polytheneType != null &&
            polytheneType == 'PP' &&
            dateString != null &&
            dateString.isNotEmpty) {
          final timestamp = DateFormat('dd/MM/yyyy, H:mm').parse(dateString);
          return DateFormat('MM').format(timestamp) == currentMonth;
        }
        return false;
      }).map<double>((doc) {
        // Check for the existence of 'quantity' field before accessing it
        if (doc['total'] != null) {
          return (doc['total'] as num).toDouble();
        }
        return 0.0;
      }).fold(0, (sum, quantity) => sum + quantity);
      //for dispatch ld
      final QuerySnapshot dispatchLDQuery =
          await firestore.collection('dispatch').get();

      dispatch_LD = dispatchLDQuery.docs.where((doc) {
        final polytheneType = doc['polythene Type'] as String?;
        final dateString = doc['date Time'] as String?;
        if (polytheneType != null &&
            polytheneType == 'LDPE' &&
            dateString != null &&
            dateString.isNotEmpty) {
          final timestamp = DateFormat('dd/MM/yyyy, H:mm').parse(dateString);
          return DateFormat('MM').format(timestamp) == currentMonth;
        }
        return false;
      }).map<double>((doc) {
        // Check for the existence of 'quantity' field before accessing it
        if (doc['total'] != null) {
          return (doc['total'] as num).toDouble();
        }
        return 0.0;
      }).fold(0, (sum, quantity) => sum + quantity);
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _refreshData() async {
    await load_DAta();
    setState(() {});
  }

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _tooltipBehavior2 = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: FutureBuilder<void>(
        future: load_DAta(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<ChartData> chartData = [
              ChartData('pp orders dispatched', dispatch_pp),
              ChartData('LD orders diapatched ', dispatch_LD),
            ];

            final List<ChartData> chartData3 = [
              ChartData(' PP', pp),
              ChartData(' LD', ld),
            ];

            return Scaffold(
              backgroundColor: Color.fromARGB(255, 173, 224, 230),
              body: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            SfCircularChart(
                              tooltipBehavior: _tooltipBehavior,
                              series: <CircularSeries>[
                                RadialBarSeries<ChartData, String>(
                                  dataSource: chartData,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  cornerStyle: CornerStyle.bothCurve,
                                  radius: '100%',
                                  enableTooltip: true,
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true),
                                  dataLabelMapper: (ChartData data, _) =>
                                      data.y.toStringAsFixed(2),
                                )
                              ],
                            ),
                            Text(
                              'Total orders dispatched \nthis month',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            SfCircularChart(
                              tooltipBehavior: _tooltipBehavior2,
                              series: <CircularSeries>[
                                RadialBarSeries<ChartData, String>(
                                  dataSource: chartData3,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  cornerStyle: CornerStyle.bothCurve,
                                  radius: '100%',
                                  enableTooltip: true,
                                  animationDuration: 1000,
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                  ),
                                  dataLabelMapper: (ChartData data, _) =>
                                      data.y.toStringAsFixed(2),
                                )
                              ],
                            ),
                            const Text(
                              'Total purchases \nthis month',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Display a loading indicator or placeholder while waiting for data.
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
