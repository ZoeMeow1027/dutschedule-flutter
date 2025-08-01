import 'package:dutschedule/utils/build_context_extension.dart';
import 'package:flutter/material.dart';

import '../../model/external_link_info.dart';
import '../../utils/app_localizations.dart';

class ExternalLinkMiscellaneousView extends StatefulWidget {
  const ExternalLinkMiscellaneousView({super.key});

  @override
  State<StatefulWidget> createState() => _ExternalLinkMiscellaneousView();
}

class _ExternalLinkMiscellaneousView extends State<ExternalLinkMiscellaneousView> {
  String _searchQuery = "";
  final _newsSearchQueryTextControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("miscellaneous_externallinks_title")),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: TextField(
              controller: _newsSearchQueryTextControl,
              onChanged: (text) => setState(() {
                _searchQuery = text;
              }),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text(AppLocalizations.of(context).translate("miscellaneous_externallinks_searchaexternallink")),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: List.generate(
                  ExternalLinkInfo.getAllExternalLinks(searchQuery: _searchQuery).length,
                  (index) {
                    var data = ExternalLinkInfo.getAllExternalLinks(searchQuery: _searchQuery).elementAt(index);
                    return Card.filled(
                      color: Theme.of(context).buttonTheme.colorScheme?.secondaryContainer,
                      margin: EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () {
                          context.openUrl(
                            data.url,
                            onFailed: () {},
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.title,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(data.url),
                                SizedBox(height: 15),
                                (data.description != null)
                                    ? Text(data.description!)
                                    : Text(AppLocalizations.of(context)
                                        .translate("miscellaneous_externallinks_nodescription")),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
