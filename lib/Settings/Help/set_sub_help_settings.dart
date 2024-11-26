import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Con_Wid.dart';
import 'package:nextapp/Constant/Constants.dart';
import 'package:nextapp/Settings/Help/contactus.dart';

import '../../Constant/Con_Clr.dart';
import '../../OSFind.dart';
import 'App_info.dart';
import 'Terms_and_Privacy Policy.dart';
import 'help_center.dart';

class sub_help_settings extends StatefulWidget {
  const sub_help_settings({Key? key}) : super(key: key);

  @override
  _sub_help_settings createState() => _sub_help_settings();
}

class _sub_help_settings extends State<sub_help_settings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Os.isIOS
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: Con_Wid.mIconButton(
                icon: Own_ArrowBack,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Con_Wid.mAppBar("Help"),
            ),
            body: _myListView(context),
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
                  "Help",
                  style: TextStyle(color: Con_white),
                )),
            child: Cupertino_myListView(context));
  }

  Widget _myListView(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView(
          children: [
            ListTile(
              visualDensity: VisualDensity(horizontal: VisualDensity.minimumDensity,vertical: VisualDensity.minimumDensity),
              onTap: () {
                Navigator.of(context).push(RouteTransitions.slideTransition( const HelpCenter()));
              },
              leading: const Icon(Icons.help_outline),
              title: const Text("Help Center",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
            ),
            Constants.SettingBuildDivider(),
            ListTile(
              visualDensity: VisualDensity(horizontal: VisualDensity.minimumDensity,vertical: VisualDensity.minimumDensity),
              onTap: () {
                Navigator.of(context).push(
                    RouteTransitions.slideTransition( const ContactUs()));
              },
              leading: const Icon(Icons.contact_mail_outlined),
              title: const Text("Contact Us",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
              subtitle: const Text("Questions? Need help?",style: TextStyle(color: Con_grey,fontSize: 12)),
            ),
            Constants.SettingBuildDivider(),
            ListTile(
              visualDensity: VisualDensity(horizontal: VisualDensity.minimumDensity,vertical: VisualDensity.minimumDensity),
              onTap: () {
                Navigator.of(context).push(RouteTransitions.slideTransition( const PrivacyPolicy()));
              },
              leading: const Icon(Icons.article),
              title: const Text("Terms and Privacy Policy",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
            ),
            Constants.SettingBuildDivider(),
            ListTile(
              visualDensity: VisualDensity(horizontal: VisualDensity.minimumDensity,vertical: VisualDensity.minimumDensity),
              onTap: () {
                Navigator.of(context).push(
                    RouteTransitions.slideTransition( const AppInfo()));
              },
              leading: const Icon(Icons.announcement_outlined),
              title: const Text("App info",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
            ),
          ],
        ));
  }

  Widget Cupertino_myListView(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView(
          children: [
            CupertinoListTile(
              onTap: () {
                Navigator.of(context).push(RouteTransitions.slideTransition( const HelpCenter()));
              },
              trailing: const Icon(CupertinoIcons.chevron_right),
              title: const Text("Help Center"),
            ),
            CupertinoListTile(
              onTap: () {
                Navigator.of(context).push(
                    RouteTransitions.slideTransition( const ContactUs()));
              },
              title: const Text("Contact Us"),
              trailing: const Icon(CupertinoIcons.chevron_right),
              subtitle: const Text("Questions? Need help?"),
            ),
            CupertinoListTile(
              onTap: () {
                Navigator.of(context).push(RouteTransitions.slideTransition( const PrivacyPolicy()));
              },
              trailing: const Icon(CupertinoIcons.chevron_right),
              title: const Text("Terms and Privacy Policy"),
            ),
            CupertinoListTile(
              onTap: () {
                Navigator.of(context).push(
                    RouteTransitions.slideTransition( const AppInfo()));
              },
              trailing: const Icon(CupertinoIcons.chevron_right),
              title: const Text("App info"),
            ),
          ],
        ));
  }
}
