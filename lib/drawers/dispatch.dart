import 'package:flutter/material.dart';
import 'package:pppi/dispatch/dispatch.dart';
import 'package:pppi/dispatch/dispatch_history.dart';
import 'package:pppi/home/home.dart';
import 'package:pppi/theme/appcolors.dart';


class dispatchdrawer extends StatefulWidget {
  const dispatchdrawer({super.key});

  @override
  State<dispatchdrawer> createState() => _dispatchdrawerState();
}

class _dispatchdrawerState extends State<dispatchdrawer> {
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors .accentColor.withOpacity(0.2),
                  AppColors.cardDark,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.accentColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: AppColors.accentColor,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => home(),
        ));
      },
      child: Theme(
        data: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.primaryDark,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.secondaryDark,
            elevation: 0,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.textSecondary),
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => home()),
              ),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.local_shipping_rounded,
                  color: AppColors.accentColor,
                ),
                SizedBox(width: 12),
                Text(
                  'Dispatch Management',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list_rounded, color: AppColors.textSecondary),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dispatch Dashboard',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Manage your deliveries and track shipments',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildFeatureCard(
                  icon: Icons.local_shipping_rounded,
                  title: 'Dispatch Goods',
                  subtitle: 'Create new dispatch entries for orders',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DispatchScreen()),
                    );
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.history_rounded,
                  title: 'Dispatch History',
                  subtitle: 'View all past dispatches and their status',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewDispatchScreen()),
                    );
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.analytics_rounded,
                  title: 'Dispatch Analytics',
                  subtitle: 'Track delivery performance and metrics',
                  onTap: () {
                    // Add analytics functionality
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.map_rounded,
                  title: 'Active Shipments',
                  subtitle: 'Monitor ongoing deliveries in real-time',
                  onTap: () {
                    // Add tracking functionality
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}