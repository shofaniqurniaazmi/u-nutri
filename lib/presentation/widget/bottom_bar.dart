// Navigation Menu with Bottom Navigation Bar
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationMenu extends StatefulWidget {
  final Widget child; // Child widget passed by ShellRoute
  const NavigationMenu({super.key, required this.child});

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Use GoRouter to navigate to the corresponding route
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          context.go('/calendar');
          break;
        case 2:
          context.go('/camera');
          break;
        case 3:
          context.go('/archive');
          break;
        case 4:
          context.go('/profile');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child, // Display the routed screen
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.purple,
        style: TabStyle.fixedCircle,
        activeColor: Colors.white,
        color: Colors.white.withOpacity(0.6),
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.calendar_today, title: 'Calendar'),
          TabItem(icon: Icons.camera, title: 'Camera'),
          TabItem(icon: Icons.archive, title: 'Archive'),
          TabItem(icon: Icons.account_circle, title: 'Profile'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}