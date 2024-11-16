import 'package:flutter/material.dart';
import 'package:pppi/HomeDashboard.dart';
import 'package:pppi/drawers/daybook.dart';
import 'package:pppi/drawers/dispatch.dart';
import 'package:pppi/drawers/order.dart';
import 'package:pppi/drawers/purchase.dart';
import 'package:pppi/orders/stock.dart';
import 'package:pppi/employee/emp.dart';
import 'package:pppi/theme/appcolors.dart';

class home extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int _selectedIndex = 0;
  Widget _body = Scaffold();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _updateBody();
    });
  }

  @override
  void initState() {
    updateStock();
    super.initState();
    _onItemTapped(0);
  }

  void _updateBody() {
    updateStock();
    switch (_selectedIndex) {
      case 0:
        _body = HomeDashBoard();
        break;
      case 1:
        _body = PurchaseDrawer();
        break;
      case 2:
        _body = dispatchdrawer();
        break;
      case 3:
        _body = OrderDrawer();
        break;
      case 4:
        _body = DaybookDrawer();
        break;
      case 5:
        _body = EmployeeDrawer();
        break;
    }
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
    String? imagePath,
  }) {
    bool isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? AppColors.accentColor.withOpacity(0.2) : Colors.transparent,
      ),
      child: ListTile(
        leading: imagePath != null
            ? Image.asset(
                imagePath,
                height: 24,
                width: 24,
                color: isSelected ? AppColors.accentColor : AppColors.textSecondary,
              )
            : Icon(
                icon,
                color: isSelected ? AppColors.accentColor : AppColors.textSecondary,
                size: 24,
              ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.accentColor : AppColors.textSecondary,
          ),
        ),
        selected: isSelected,
        onTap: () {
          _onItemTapped(index);
          widget.scaffoldKey.currentState?.openEndDrawer();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.primaryDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.secondaryDark,
          elevation: 0,
        ),
      ),
      child: Scaffold(
        key: widget.scaffoldKey,
        appBar: AppBar(),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _body,
        ),
        drawer: Drawer(
          backgroundColor: AppColors.primaryDark,
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: AppColors.secondaryDark,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.accentColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.business,
                          size: 40,
                          color: AppColors.accentColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Parmarth Print Pack',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Industry Management',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(
                      icon: Icons.dashboard_rounded,
                      title: 'Dashboard',
                      index: 0,
                    ),
                    _buildDrawerItem(
                      icon: Icons.shopping_cart_rounded,
                      title: 'Purchase',
                      index: 1,
                    ),
                    _buildDrawerItem(
                      icon: Icons.local_shipping_rounded,
                      title: 'Dispatch',
                      index: 2,
                    ),
                    _buildDrawerItem(
                      icon: Icons.assignment_rounded,
                      title: 'Order',
                      index: 3,
                    ),
                    _buildDrawerItem(
                      icon: Icons.book_rounded,
                      title: 'Daybook',
                      index: 4,
                    ),
                    _buildDrawerItem(
                      icon: Icons.people_rounded,
                      title: 'Employees',
                      index: 5,
                    ),
                    const Divider(color: AppColors.secondaryDark, height: 32),
                    _buildDrawerItem(
                      icon: Icons.settings_rounded,
                      title: 'Settings',
                      index: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
