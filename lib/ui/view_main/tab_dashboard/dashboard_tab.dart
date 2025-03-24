import '../../../utils/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../view_settings/settings_view.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("app_name")),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsView()),
                // PageRouteBuilder(
                //   pageBuilder: (context, animation, secondaryAnimation) => SettingsView(),
                //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
                //     // const begin = Offset(0.0, 1.0);
                //     // const end = Offset.zero;
                //     // const curve = Curves.linearToEaseOut;
                //     //
                //     // var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                //     //
                //     // return SlideTransition(position: animation.drive(tween), child: child);
                //     // return ScaleTransition(
                //     //   scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                //     //     CurvedAnimation(
                //     //       parent: animation,
                //     //       curve: Curves.fastOutSlowIn,
                //     //     ),
                //     //   ),
                //     //   child: FadeTransition(
                //     //     opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                //     //       CurvedAnimation(
                //     //         parent: animation,
                //     //         curve: Curves.fastOutSlowIn,
                //     //       ),
                //     //     ),
                //     //     child: child,
                //     //   ),
                //     // );
                //   },
                // ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
