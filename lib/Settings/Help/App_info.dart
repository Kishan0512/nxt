import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextapp/Constant/Con_Wid.dart';

import '../../Constant/Con_Clr.dart';
import '../../Constant/Con_Icons.dart';
import '../../Constant/Con_Usermast.dart';
import '../../OSFind.dart';

class AppInfo extends StatefulWidget {
  const AppInfo({Key? key}) : super(key: key);

  @override
  State<AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
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
              title: const Text("App info"),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "NxtApp",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Version 2.22.10.73",
                      style: TextStyle(fontSize: 14, color: Con_grey),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(
                          Constants_Usermast.user_appfirstscreen_logo),
                      height: 130,
                      width: 150,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "@ 2022 - 2.22.10.73",
                      style: TextStyle(fontSize: 14, color: Con_grey),
                    ),
                  ],
                ),
                const SizedBox(height: 130),
              ],
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
                  "App info",
                  style: TextStyle(color: Con_white),
                )),
            child: Material(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "NxtApp",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Version 2.22.10.73",
                        style: TextStyle(fontSize: 14, color: Con_grey),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage(
                            Constants_Usermast.user_appfirstscreen_logo),
                        height: 130,
                        width: 150,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "@ 2022 - 2.22.10.73",
                        style: TextStyle(fontSize: 14, color: Con_grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 130),
                ],
              ),
            ));
  }
}
