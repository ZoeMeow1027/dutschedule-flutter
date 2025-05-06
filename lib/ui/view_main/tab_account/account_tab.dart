import '../../../utils/build_context_extension.dart';
import 'package:flutter/material.dart';

import '../../../utils/get_device_type.dart';
import 'account_mobile_view.dart';
import 'account_tablet_view.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<StatefulWidget> createState() => _AccountTab();
}

class _AccountTab extends State<AccountTab> {
  late AccountLoginTemporary accTemporary;

  @override
  void initState() {
    accTemporary = AccountLoginTemporary();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return context.getDeviceType().value > DeviceType.tablet.value
        ? AccountTabletView(
            accTemp: accTemporary,
            accTempValueChanged: (valueChanged) => setState(() {
              accTemporary = valueChanged;
            }),
          )
        : AccountMobileView(
            accTemp: accTemporary,
            accTempValueChanged: (valueChanged) => setState(() {
              accTemporary = valueChanged;
            }),
          );
  }
}

class AccountLoginTemporary {
  final String username;
  final String password;
  final bool rememberLogin;

  AccountLoginTemporary({
    this.username = "",
    this.password = "",
    this.rememberLogin = false,
  });

  AccountLoginTemporary clone({
    String? username,
    String? password,
    bool? rememberLogin,
  }) {
    return AccountLoginTemporary(
      username: username ?? this.username,
      password: password ?? this.password,
      rememberLogin: rememberLogin ?? this.rememberLogin,
    );
  }
}
