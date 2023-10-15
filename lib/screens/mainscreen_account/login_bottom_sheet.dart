import 'package:flutter/material.dart';

import '/utils/theme_tools.dart';

class AccountLoginBottomSheet extends StatefulWidget {
  const AccountLoginBottomSheet({
    super.key,
    this.onClickLogin,
  });

  final Future<Map<String, dynamic>?> Function(String, String, bool)?
      onClickLogin;

  @override
  State<StatefulWidget> createState() => _AccountLoginBottomSheetState();
}

class _AccountLoginBottomSheetState extends State<AccountLoginBottomSheet> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _rememberLoginChecked = false;
  bool _controlEnabled = true;
  String _statusText = "";

  @override
  Widget build(BuildContext context) {
    void actionLogin() {
      if (_controlEnabled) {
        setState(() {
          _controlEnabled = false;
          _statusText = "Logging in...";
        });
        if (widget.onClickLogin != null) {
          widget.onClickLogin!(
            _userController.text,
            _passController.text,
            _rememberLoginChecked,
          )
              .then((value) {
            if (value!["status"] != true) {
              setState(() {
                _controlEnabled = true;
                _statusText = value["msg"];
              });
            } else {
              setState(() {
                _statusText = value["msg"];
              });
            }
          });
        }
      }
    }

    return Container(
      margin: const EdgeInsets.only(top: 10, left: 30, right: 30),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(
              "Login",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: TextField(
              enabled: _controlEnabled,
              controller: _userController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: TextField(
              enabled: _controlEnabled,
              obscureText: true,
              controller: _passController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          InkWell(
            onTap: _controlEnabled
                ? () {
                    setState(() {
                      _rememberLoginChecked = !_rememberLoginChecked;
                    });
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Checkbox(
                      value: _rememberLoginChecked,
                      onChanged: (bool? value) {
                        if (_controlEnabled) {
                          setState(() {
                            _rememberLoginChecked = value!;
                          });
                        }
                      },
                    ),
                  ),
                  const Text("Remember my login"),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: ElevatedButton(
              onPressed: () {
                actionLogin();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
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
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              _statusText,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
