import 'package:url_launcher/url_launcher.dart';

class Command {
  static final commands = [browse, open, email, search];

  static const browse = "go to";
  static const open = "open";
  static const email = "email";
  static const search = "google";
}

class Utils {
  static void checkText(String usertext) {
    final text = usertext.toLowerCase();
    if (text.contains(Command.email)) {
      final body = _getTextAfterCmd(text: text, cmd: Command.email);
      openEmail(body: body);
    } else if (text.contains(Command.browse)) {
      final url = _getTextAfterCmd(text: text, cmd: Command.browse);
      openLink(url: url);
    } else if (text.contains(Command.open)) {
      final url = _getTextAfterCmd(text: text, cmd: Command.open);
      openLink(url: url);
    } else if (text.contains(Command.search)) {
      final url =
          "www.google.com/search?q=${_getTextAfterCmd(text: text, cmd: Command.search)}";
      openLink(url: url);
    }
  }

  static String? _getTextAfterCmd({
    required String text,
    required String cmd,
  }) {
    final commandStartIndex = text.indexOf(cmd);
    final commandEndIndex = commandStartIndex + cmd.length;

    if (commandStartIndex == -1) {
      return null;
    } else {
      return text.substring(commandEndIndex).trim();
    }
  }

  static Future openEmail({required String? body}) async {
    final url = 'mailto: ?body=${Uri.encodeFull(body!)}';
    await _launchUrl(url);
  }

  static Future openLink({required String? url}) async {
    if (url!.trim().isEmpty) {
      await _launchUrl("https://google.com");
    } else {
      if (!(url.trim().contains('.com'))) {
        await _launchUrl("https://www.google.com/search?q=$url");
      } else
        await _launchUrl("https://$url");
    }
  }

  static Future _launchUrl(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      }
    } catch (e) {
      print(e);
    }
  }
}
