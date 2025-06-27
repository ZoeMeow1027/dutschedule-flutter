import 'package:flutter/widgets.dart';

import '../../../utils/app_localizations.dart';
import '../card_with_title.dart';

class ExternalLinksCard extends StatelessWidget {
  const ExternalLinksCard({
    super.key,
    this.onClick,
  });

  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return CardWithTitle(
      padding: EdgeInsets.symmetric(vertical: 3),
      title: AppLocalizations.of(context).translate("main_dashboard_widget_externallinks_title"),
      onClick: onClick,
      child: Text(AppLocalizations.of(context).translate("main_dashboard_widget_externallinks_description")),
    );
  }
}
