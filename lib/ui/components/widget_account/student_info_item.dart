import 'package:flutter/material.dart';

import '../../../utils/app_localizations.dart';
import '../../../utils/string_utils.dart';

class StudentInfoItem extends StatelessWidget {
  const StudentInfoItem({
    super.key,
    required this.name,
    required this.value,
    this.onCopy,
  });

  final String? name;
  final String? value;
  final Function(String)? onCopy;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 7, bottom: 9, left: 12, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
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
