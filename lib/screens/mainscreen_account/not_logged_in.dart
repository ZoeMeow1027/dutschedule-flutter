import 'package:flutter/material.dart';

import '/utils/theme_tools.dart';

class AccountNotLoggedInView extends StatelessWidget {
  const AccountNotLoggedInView({super.key, this.onClicked});

  final Function? onClicked;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: ThemeTool.isDarkMode(context)
                      ? Colors.white
                      : Colors.black,
                ),
                children: [
                  WidgetSpan(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: const Text(
                        "You are not logged in",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(
                    text:
                        "\nTo use this function, you need to be logged in. Click button below to login.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: ElevatedButton(
                onPressed: () {
                  if (onClicked != null) {
                    onClicked!();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 18,
                  ),
                  backgroundColor: ThemeTool.isDarkMode(context)
                      ? Theme.of(context).highlightColor
                      : null,
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
