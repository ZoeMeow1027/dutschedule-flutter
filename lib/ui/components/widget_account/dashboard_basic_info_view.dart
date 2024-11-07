import 'package:flutter/material.dart';

import '../../../utils/app_localizations.dart';

class DashboardBasicInfoView extends StatelessWidget {
  const DashboardBasicInfoView({
    super.key,
    this.padding,
    this.name,
    this.studentId,
    this.schoolClass,
    this.specialization,
    this.isRunning = false,
    this.onClick,
  });

  final EdgeInsets? padding;
  final String? name, studentId, schoolClass, specialization;
  final bool isRunning;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      child: Card.filled(
        child: InkWell(
          onTap: () => onClick?.call(),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate("account_dashboard_banner_title"),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(AppLocalizations.of(context).translate("account_dashboard_banner_titleclick")),
                    ],
                  ),
                ),
                !isRunning
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_circle_outlined,
                            size: 64,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Text(
                              name ?? AppLocalizations.of(context).translate("account_dashboard_banner_title"),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Text(
                              "${studentId ?? AppLocalizations.of(context).translate("data_unknown")} - ${schoolClass ?? AppLocalizations.of(context).translate("data_unknown")}"),
                          Text(specialization ?? AppLocalizations.of(context).translate("data_unknown")),
                        ],
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: const CircularProgressIndicator(),
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
