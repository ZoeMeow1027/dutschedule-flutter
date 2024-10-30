import 'package:dutschedule/utils/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/account_session_instance.dart';
import '../../components/message_card.dart';

class AccountDashboardView extends StatelessWidget {
  const AccountDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final accountSessionInstance = Provider.of<AccountSessionInstance>(context);
    return Padding(
      padding: const EdgeInsets.only(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Processing status
          MessageCard.processing(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Fetching from sv.dut.udn.vn...",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onClick: () {},
          ),
          MessageCard.warning(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "We can't fetch any information from sv.dut.udn.vn. Please check your internet connection.\nIf everything fine, please try again later.\nClick here to try again.",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: context.isDarkMode() ? Colors.black : null),
            ),
            onClick: () {},
          ),
          // Account Information
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card.filled(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle_outlined,
                      size: 64,
                    ),
                    Text("---------------------"),
                    Text("xxxxxxxxx - 19TDDD-DTx"),
                    Text("Information Technology"),
                  ],
                ),
              ),
            ),
          ),
          // Button action
          _customButton(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
            child: Text("View subject information"),
            onPressed: () {},
          ),
          _customButton(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
            child: Text("View subject fee list"),
            onPressed: () {},
          ),
          _customButton(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
            child: Text("View basic information"),
            onPressed: () {},
          ),
          _customButton(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
            child: Text("View training result"),
            onPressed: () {},
          ),
          _customButton(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
            child: Text("Logout"),
            onPressed: () {
              accountSessionInstance.logout(afterRun: () {
                context.clearSnackBars();
                context.showSnackBar(SnackBar(
                  content: Text("Successfully logout!"),
                ));
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _customButton({
    required Widget child,
    EdgeInsets padding = EdgeInsets.zero,
    Function()? onPressed,
  }) {
    return Padding(
      padding: padding,
      child: FilledButton.tonal(
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }
}
