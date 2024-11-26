import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Constant/Con_Clr.dart';
import '../../Constant/Con_Icons.dart';
import '../../Constant/Con_Wid.dart';
import '../../OSFind.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({Key? key}) : super(key: key);

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  bool isSearching = false;
  final TextEditingController _searchQuery = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Os.isIOS
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              iconTheme: const IconThemeData(color: Con_white),
              actionsIconTheme: const IconThemeData(color: Con_white),
              leading: isSearching
                  ? Con_Wid.mIconButton(
                      icon: Own_ArrowBack,
                      onPressed: () {
                        setState(() {
                          isSearching = false;
                          _searchQuery.text = "";
                        });
                      },
                    )
                  : Con_Wid.mIconButton(
                      icon: Own_ArrowBack,
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    ),
              title: const Text("Help Center"),
            ),
          )
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                padding: EdgeInsetsDirectional.zero,
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.back, color: Con_white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: App_Float_Back_Color,
                middle: const Text(
                  "Help Center",
                  style: TextStyle(color: Con_white),
                )),
            child: Container());
  }
}
