import 'package:flutter/material.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Constant/Con_Wid.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../Constant/Con_Clr.dart';

class theme extends StatefulWidget {
  const theme({Key? key}) : super(key: key);

  @override
  _themeState createState() => _themeState();
}

class _themeState extends State<theme> {
  void Themechange() async {
    SharedPreferences th = await SharedPreferences.getInstance();
    var gv = th.getInt("groupvalue") ?? 0;
    setState(() {
      Constants_Usermast.user_theme_setting = gv;
    });
  }

  @override
  void initState() {
    super.initState();
    Themechange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Con_Wid.mIconButton(
          icon: Own_ArrowBack,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Con_Wid.mAppBar("Theme"),
      ),
      body: ListView(
        children: [
          RadioListTile(
            selectedTileColor: Con_grey,
            value: 0,
            groupValue: Constants_Usermast.user_theme_setting,
            onChanged: (int? val) async {
              setState(() {
                Constants_Usermast.user_theme_setting = val!;
              });
              SharedPreferences th = await SharedPreferences.getInstance();
              th.setInt("groupvalue", 0);
              setState(() {
                Constants_Usermast.user_theme_setting = 0;
                // ThemeModeBuilderConfig.setSystem();
              });
            },
            title: const Text("System Default"),
          ),
          RadioListTile(
            value: 1,
            groupValue: Constants_Usermast.user_theme_setting,
            onChanged: (int? val) async {
              setState(() {
                Constants_Usermast.user_theme_setting = val!;
              });
              SharedPreferences th = await SharedPreferences.getInstance();
              th.setInt("groupvalue", 1);
              setState(() {
                Constants_Usermast.user_theme_setting = 1;
                // ThemeModeBuilderConfig.setLight();
              });
            },
            title: const Text("Light"),
          ),
          RadioListTile(
            value: 2,
            groupValue: Constants_Usermast.user_theme_setting,
            onChanged: (int? val) async {
              setState(() {
                Constants_Usermast.user_theme_setting = val!;
              });
              SharedPreferences th = await SharedPreferences.getInstance();
              th.setInt("groupvalue", 2);
              setState(() {
                Constants_Usermast.user_theme_setting = 2;
                // ThemeModeBuilderConfig.setDark();
              });
            },
            title: const Text("Dark"),
          )
        ],
      ),
    );
  }
}
