import '../../../utils/build_context_extension.dart';
import 'package:flutter/material.dart';

import '../../../utils/get_device_type.dart';
import 'account_mobile_view.dart';
import 'account_tablet_view.dart';

class AccountTab extends StatelessWidget {
  const AccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    return context.getDeviceType().value > DeviceType.tablet.value ? AccountTabletView() : AccountMobileView();
  }
}
