import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextapp/OSFind.dart';

import '../Constant/Con_Clr.dart';

class Emoji_Widget extends StatelessWidget {
  TextEditingController controller;

  Emoji_Widget({Key? key, required this.controller}) : super(key: key);

  _onEmojiSelected(Emoji emoji) {
    controller.text += emoji.emoji;
  }

  _onBackspacePressed() {
    controller.text = controller.text.characters.skipLast(1).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Os.isIOS? EmojiPicker(
      config: const Config(
        iconColorSelected: Con_Main_1,
        columns: 8,
        backspaceColor: Con_Main_1,
        buttonMode: ButtonMode.MATERIAL,
        indicatorColor: Con_Main_1,
      ),
      onEmojiSelected: (category, emoji) {
        _onEmojiSelected(emoji);
      },
      onBackspacePressed: _onBackspacePressed,
    ):CupertinoPageScaffold(
      child: EmojiPicker(
        config: Config(
          iconColorSelected: Con_Main_1,
          columns: 8,
          backspaceColor: Con_Main_1,
          buttonMode: ButtonMode.CUPERTINO,
          indicatorColor: Con_Main_1,
        ),
        onEmojiSelected: (category, emoji) {
          _onEmojiSelected(emoji);
        },
      ),
    );
  }
}
