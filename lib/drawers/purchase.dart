import 'package:flutter/material.dart';
import 'package:pppi/purchase/add_raw.dart';
import 'package:pppi/home/home.dart';
import 'package:pppi/purchase/purchase_history.dart';
import 'package:pppi/theme/appcolors.dart';



class PurchaseDrawer extends StatefulWidget {
  const PurchaseDrawer({super.key});

  @override
  State<PurchaseDrawer> createState() => _PurchaseDrawerState();
}

class _PurchaseDrawerState extends State<PurchaseDrawer> {
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
                  Icons.shopping_cart_rounded,
                  color: AppColors.accentColor,
                ),
                SizedBox(width: 12),
                Text(
                  'Purchase Management',
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
                        'Purchase Dashboard',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Manage your inventory and purchase records',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildFeatureCard(
                  icon: Icons.add_shopping_cart_rounded,
                  title: 'Add Purchase Records',
                  subtitle: 'Record new purchases of PP, LD, ink, and more',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddRawMaterialScreen()),
                    );
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.history_rounded,
                  title: 'Purchase History',
                  subtitle: 'View and analyze past purchase records',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewInventoryScreen()),
                    );
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.analytics_rounded,
                  title: 'Purchase Analytics',
                  subtitle: 'View insights and trends',
                  onTap: () {
                    // Add analytics functionality
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