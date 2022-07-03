import 'package:url_launcher/url_launcher.dart';

void setEmailToAdmin({required String subject}) {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  //open mail page
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'ughub2@gmail.com',
    query: encodeQueryParameters(<String, String>{'subject': subject}),
  );

  launchUrl(emailLaunchUri);
}
