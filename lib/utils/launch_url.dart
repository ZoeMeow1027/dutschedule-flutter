import 'package:url_launcher/url_launcher.dart';

void launchOwnUrl(
  String url, {
  Function()? onFailed,
}) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(
      Uri.parse(url),
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true,
        enableDomStorage: true,
      ),
    );
  } else {
    if (onFailed != null) {
      onFailed();
    }
  }
}
