import 'package:blood_bank/ui/layouts/auth/widgets/backgrond_auth.dart';
import 'package:blood_bank/ui/layouts/auth/widgets/custom_title.dart';
import 'package:blood_bank/ui/layouts/auth/widgets/links_bar.dart';
import 'package:blood_bank/utils/create_material_color.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;

  const AuthLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Scrollbar(
        isAlwaysShown: true,
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            (size.width > 1000)
                ?
                //Desktop
                _DesktopBody(
                    child: child,
                  )
                :
                //Mobile
                _MobileBody(
                    child: child,
                  ),
            // Linksbar
            LinkBar(),
          ],
        ),
      ),
    );
  }
}

class _DesktopBody extends StatelessWidget {
  final Widget child;

  const _DesktopBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height * 0.95,
      child: Row(
        children: [
          /* Todo background */

          BackgroundAuth(),
          /* Parte del layout */
          Container(
            width: (size.width * 1.5) / 4,
            height: double.infinity,
            color: createMaterialColor(Color(0xFF003F66)),
            child: Column(
              children: [
                CustomTitle(),
                SizedBox(
                  height: 20,
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileBody extends StatelessWidget {
  final Widget child;

  const _MobileBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: createMaterialColor(Color(0xFF003F66)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          CustomTitle(),
          Container(
            width: double.infinity,
            height: 420,
            child: child,
          ),
          Container(
            width: double.infinity,
            height: 400,
            child: BackgroundAuth(),
          ),
        ],
      ),
    );
  }
}
