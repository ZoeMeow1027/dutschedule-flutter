import 'package:dutschedule/utils/launch_url.dart';
import 'package:dutschedule/utils/theme_tools.dart';
import 'package:flutter/material.dart';

class AccountNotLoggedInView extends StatelessWidget {
  const AccountNotLoggedInView({
    super.key,
    required this.username,
    required this.password,
    required this.rememberLogin,
    required this.onAuthInfoChanged,
    required this.loginRequested,
    required this.isProcessing,
  });

  // Username, password, remember password
  final String username, password;
  final bool rememberLogin;
  final Function(String, String, bool) onAuthInfoChanged;
  final Function() loginRequested;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Login",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: "\nUse your account from sv.dut.udn.vn to login.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: TextField(
                enabled: !isProcessing,
                onChanged: (changed) {
                  onAuthInfoChanged(changed, password, rememberLogin);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username (Student ID)',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                enabled: !isProcessing,
                onChanged: (changed) {
                  onAuthInfoChanged(username, changed, rememberLogin);
                },
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: isProcessing
                    ? null
                    : () {
                        onAuthInfoChanged(username, password, !rememberLogin);
                      },
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          onChanged: isProcessing
                              ? null
                              : (checked) {
                                  onAuthInfoChanged(
                                    username,
                                    password,
                                    checked ?? !rememberLogin,
                                  );
                                },
                          value: rememberLogin,
                        ),
                        Text("Remember my login")
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(),
              child: FilledButton(
                onPressed: () {
                  loginRequested();
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 18,
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Text("Forgot your password?"),
                ),
                onTap: () {
                  if (!isProcessing) {
                    launchOwnUrl(
                      "https://github.com/ZoeMeow1027/DutSchedule/wiki/Changing-Password-In-DUT#qu%C3%AAn-m%E1%BA%ADt-kh%E1%BA%A9u",
                      onFailed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("We can't open links for you."),
                        ));
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
