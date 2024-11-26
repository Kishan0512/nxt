import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Constant/Con_Clr.dart';
import '../../Constant/Con_Icons.dart';
import '../../Constant/Con_Wid.dart';
import '../../OSFind.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  bool isSearching = false;
  final TextEditingController _searchQuery = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Os.isIOS
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: true,
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
              title: const Text("Terms and Privacy Policy"),
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
                  "Terms and Privacy Policy",
                  style: TextStyle(color: Con_white),
                )),
            child: Container());
  }
}
