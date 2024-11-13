import 'package:flutter/material.dart';

import '../../utils/app_localizations.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    this.description,
    this.showNoDataText = false,
    this.showBorder = true,
    this.trailingWidget,
    this.onClick,
  });

  final String title;
  final String? description;
  final bool showNoDataText;
  final Widget? trailingWidget;
  final bool showBorder;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 3),
      child: Card.filled(
        shape: showBorder
            ? RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1.5),
                borderRadius: BorderRadius.circular(15),
              )
            : null,
        child: InkWell(
          onTap: onClick,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          description?.isNotEmpty == true
                              ? description!
                              : showNoDataText
                                  ? AppLocalizations.of(context).translate("data_nodata")
                                  : "",
                        ),
                      ),
                    ],
                  ),
                ),
                trailingWidget != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: trailingWidget,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
