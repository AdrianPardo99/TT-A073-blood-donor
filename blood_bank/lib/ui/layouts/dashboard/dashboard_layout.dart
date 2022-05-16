import 'package:blood_bank/ui/shared/sidebar.dart';
import 'package:flutter/material.dart';

class DashboardLayout extends StatelessWidget {
  final Widget child;

  const DashboardLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEDF1F2),
        body: Row(
          children: [
            /* TODO mas de 700 px */
            Sidebar(),
            Expanded(child: child),
          ],
        ));
  }
}
