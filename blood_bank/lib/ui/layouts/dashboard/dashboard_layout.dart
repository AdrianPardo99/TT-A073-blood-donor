import 'package:flutter/material.dart';

import 'package:blood_bank/ui/shared/navbar.dart';
import 'package:blood_bank/ui/shared/sidebar.dart';
import 'package:blood_bank/providers/side_menu_provider.dart';

class DashboardLayout extends StatefulWidget {
  final Widget child;

  const DashboardLayout({super.key, required this.child});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SideMenuProvider.menuController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFEDF1F2),
      body: Stack(
        children: [
          Row(
            children: [
              /* TODO mas de 700 px */
              if (size.width >= 700) Sidebar(),
              Expanded(
                child: Column(
                  children: [
                    /* Navbar */
                    Navbar(),
                    /* View */
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: widget.child,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          if (size.width < 700)
            AnimatedBuilder(
              animation: SideMenuProvider.menuController,
              builder: (context, _) => Stack(
                children: [
                  if (SideMenuProvider.isOpen)
                    Opacity(
                      opacity: SideMenuProvider.opacity.value,
                      child: GestureDetector(
                        onTap: () => SideMenuProvider.closeMenu(),
                        child: Container(
                          width: size.width,
                          height: size.height,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                  Transform.translate(
                    offset: Offset(SideMenuProvider.movement.value, 0),
                    child: Sidebar(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
