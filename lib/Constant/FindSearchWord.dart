import 'package:flutter/material.dart';

import 'Con_Clr.dart';

class FindSearchWord extends StatefulWidget {
  const FindSearchWord(
      {super.key,
      required this.pStrText,
      required this.pStrId,
      required this.OnChange,
      required this.SearchSelected,
      required this.pStrTextController});

  final String pStrText;
  final String pStrId;
  final String pStrTextController;
  final ValueChanged<String> OnChange;
  final String SearchSelected;

  @override
  State<FindSearchWord> createState() => _FindSearchWordState();
}

class _FindSearchWordState extends State<FindSearchWord> {
  @override
  Widget build(BuildContext context) {
    final search = widget.pStrTextController;
    final text = widget.pStrText;
    final matches = search.allMatches(text.toLowerCase()).toList();

    final spans = <TextSpan>[];
    if (matches.isEmpty) {
      spans.add(textSpan(text, Con_black));
    } else {
      if(mounted) {
        widget.OnChange.call(widget.pStrId);
      }
      for (var i = 0; i < matches.length; i++) {
        final strStart = i == 0 ? 0 : matches[i - 1].end;
        final match = matches[i];
        spans.add(
          textSpan(
              text.substring(
                strStart,
                match.start,
              ),
              Con_black),
        );
        spans.add(
          textSpan(
            text.substring(
              match.start,
              match.end,
            ),
            widget.SearchSelected == widget.pStrId ? Con_black :  Con_white,
            pClrBgColor: widget.SearchSelected == widget.pStrId
                ? Colors.yellowAccent
                : searchTextBgColor,
          ),
        );
      }
      spans.add(textSpan(text.substring(matches.last.end), Con_black));
    }

    return Text.rich(
      TextSpan(children: spans),
    );
  }

  textSpan(String pStrText, Color pClrColor, {Color? pClrBgColor}) {
    return TextSpan(
      text: pStrText,
      style: TextStyle(
          fontSize: 16, color: pClrColor, backgroundColor: pClrBgColor),
    );
  }
}
