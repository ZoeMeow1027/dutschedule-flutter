import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/string_utils.dart';

class StudentInfoItem extends StatelessWidget {
  const StudentInfoItem({
    super.key,
    required this.name,
    required this.value,
    this.shouldRadiusOnTop = false,
    this.shouldRadiusOnBottom = false,
    this.onCopy,
  });

  final String? name;
  final String? value;
  final bool shouldRadiusOnTop;
  final bool shouldRadiusOnBottom;
  final Function(String)? onCopy;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondaryContainer,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(shouldRadiusOnTop ? 20 : 5),
        topLeft: Radius.circular(shouldRadiusOnTop ? 20 : 5),
        bottomLeft: Radius.circular(shouldRadiusOnBottom ? 20 : 5),
        bottomRight: Radius.circular(shouldRadiusOnBottom ? 20 : 5),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 9, bottom: 11, left: 14, right: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? AppLocalizations.of(context).translate("data_unknown"),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    value ?? AppLocalizations.of(context).translate("data_unknown"),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                onCopy?.call(StringUtils.formatString(
                  "{0}: {1}",
                  [
                    name ?? AppLocalizations.of(context).translate("data_unknown"),
                    value ?? AppLocalizations.of(context).translate("data_unknown")
                  ],
                ));
              },
              icon: Icon(Icons.copy),
            ),
          ],
        ),
      ),
    );
  }
}
