// lib/sidebar.dart
import 'package:flutter/material.dart';
import '../services/fetchOrders.dart';
import '../services/postOrder.dart';
import '../components/active_orders_grid.dart';
import '../components/order_details_section.dart';
import '../constants/constants.dart';

class Sidebar extends StatefulWidget {
  //final List<Map<String, dynamic>> ordersList;
  final List<Map<String, dynamic>> cartItems;
  final VoidCallback onOrderSuccess;
  
  const Sidebar({
    super.key,
    required this.cartItems,
    required this.onOrderSuccess,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await FetchOrders.fetchOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      //print('Error loading orders: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _postOrder() async {
    try {
      await OrderService.postOrders(
        widget.cartItems,
        "user9123456789",
        "out9987654321",
        _nextOrderNumber,
      );
      widget.onOrderSuccess(); 
      await _loadOrders();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed successfully!'),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to place order. Please try again.'),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      //print('Error posting order: $e');
    }
  }
  int get _nextOrderNumber => (_orders.isNotEmpty ? _orders.last['OrderNum'] as int : 0) + 1;


  List<Map<String, dynamic>> get _activeOrders =>
      _orders.where((order) => order['Status'] == 'Active').toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(2, 0),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildLogo(),
          //const SizedBox(height: 24),
          _buildActiveOrdersSection(context),
          const SizedBox(height: 24),
          Expanded(
            child: OrderDetailsSection(
              cartItems: widget.cartItems,
              nextOrderNumber: _nextOrderNumber,
              onConfirm: _postOrder,
              onPay: () {}, 
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Image.asset(
      'lib/assets/logoR.png',
      height: 20,
      fit: BoxFit.contain,
    ),
  );

  Widget _buildActiveOrdersSection(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: AppDecorations.sidebarContainer(context),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Active Orders", style: AppTextStyles.titleLarge),
        const SizedBox(height: 12),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ActiveOrdersGrid(activeOrders: _activeOrders),
        ),
      ],
    ),
  );
}
