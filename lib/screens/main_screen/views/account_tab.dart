import 'package:flutter/material.dart';

import '../../../utils/theme_tools.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<StatefulWidget> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab>
    with AutomaticKeepAliveClientMixin<AccountTab> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
      ),
      body: _notLoggedIn(context),
    );
  }

  Widget _notLoggedIn(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: ThemeTool.isDarkMode(context) ? Colors.white : Colors.black,
                ),
                children: [
                  WidgetSpan(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: const Text(
                        "You are not logged in",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(
                    text:
                        "\nTo use this function, you need to be logged in. Click button below to login.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
