import 'package:flutter/material.dart';
import 'package:pppi/daybook/add_record.dart';
import 'package:pppi/daybook/daybook.dart';
import 'package:pppi/home/home.dart';
import 'package:pppi/theme/appcolors.dart';

class DaybookDrawer extends StatefulWidget {
  const DaybookDrawer({super.key});

  @override
  State<DaybookDrawer> createState() => _DaybookDrawerState();
}

class _DaybookDrawerState extends State<DaybookDrawer> {
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
                  AppColors.accentColor.withOpacity(0.2),
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
                  Icons.book_rounded,
                  color: AppColors.accentColor,
                ),
                SizedBox(width: 12),
                Text(
                  'Daybook Records',
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
                icon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.analytics_rounded, color: AppColors.textSecondary),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daybook Dashboard',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Track and manage daily expenses and records',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildFeatureCard(
                  icon: Icons.note_add_outlined,
                  title: 'Add Daybook Record',
                  subtitle: 'Record new daily expenses and transactions',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddRecord()),
                    );
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.import_export_rounded,
                  title: 'View History',
                  subtitle: 'Browse and analyze past expense records',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DaybookHistoryScreen()),
                    );
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.analytics_outlined,
                  title: 'Expense Analytics',
                  subtitle: 'View expense trends and insights',
                  onTap: () {
                    // Add analytics functionality
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.summarize_rounded,
                  title: 'Monthly Summary',
                  subtitle: 'View monthly expense breakdowns',
                  onTap: () {
                    // Add monthly summary functionality
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