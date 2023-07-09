import 'package:dutwrapper/model/news_obj.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/theme_tools.dart';

class NewsDetailItem extends StatelessWidget {
  const NewsDetailItem({
    super.key,
    required this.newsItem,
    this.isNewsSubject = false,
    this.onClickUrl,
  });
  
  final NewsGlobal newsItem;
  final bool isNewsSubject;
  final Function(String)? onClickUrl;

@override
  Widget build(BuildContext context) {
    var dateStr = DateFormat("dd/MM/yyyy")
        .format(DateTime.fromMillisecondsSinceEpoch(newsItem.date));

    // String to richtext
    List<_NewsTextProcessing> data = _richText(
      source: newsItem.contentString,
      newsLinkItem: List.of(newsItem.links),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              newsItem.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                dateStr,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const Divider(
              height: 10,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: RichText(
                text: TextSpan(
                  children: List.generate(
                    data.length,
                    (index) {
                      return TextSpan(
                        text: data[index].text,
                        style: TextStyle(
                          decoration: data[index].url == null
                              ? null
                              : TextDecoration.underline,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          color: data[index].url != null
                              ? Colors.blueAccent
                              : ThemeTool.isDarkMode(context)
                                ? Colors.white
                                : Colors.black,
                        ),
                        recognizer: data[index].url == null
                            ? null
                            : (TapGestureRecognizer()
                              ..onTap = () {
                                if (onClickUrl != null &&
                                    data[index].url != null) {
                                  onClickUrl!(data[index].url!);
                                }
                              }),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_NewsTextProcessing> _richText({
    required String source,
    required List<NewsLinkItem> newsLinkItem,
  }) {
    List<_NewsTextProcessing> data = [];

    // Process a starter string...
    // If newsLinkItem is empty, return entire source string as nolink,
    // and return
    if (newsLinkItem.isEmpty) {
      data.add(_NewsTextProcessing(text: source));
      return data;
    }
    // Otherwise, just continue
    data.add(_NewsTextProcessing(
      text: source.substring(0, source.indexOf(newsLinkItem[0].text)),
    ));
    source = source.replaceRange(0, source.indexOf(newsLinkItem[0].text), "");

    // While processing
    while (newsLinkItem.isNotEmpty) {
      data.add(_NewsTextProcessing(
        text: newsLinkItem[0].text,
        url: newsLinkItem[0].url,
      ));
      source = source.replaceRange(
          0,
          source.indexOf(newsLinkItem[0].text) + newsLinkItem[0].text.length,
          "");
      newsLinkItem.removeAt(0);
      if (newsLinkItem.isNotEmpty) {
        if (source.indexOf(newsLinkItem[0].text) > 0) {
          data.add(_NewsTextProcessing(
            text: source.substring(0, source.indexOf(newsLinkItem[0].text)),
          ));
          source =
              source.replaceRange(0, source.indexOf(newsLinkItem[0].text), "");
        }
      }
    }

    if (source.isNotEmpty) {
      data.add(_NewsTextProcessing(text: source));
      source = "";
    }

    // End of processing
    return data;
  }
}

class _NewsTextProcessing {
  late String text;
  String? url;

  _NewsTextProcessing({required this.text, this.url});
}