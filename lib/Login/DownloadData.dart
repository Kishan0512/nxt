import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nextapp/A_FB_Trigger/SharedPref.dart';
import 'package:nextapp/A_Local_DB/Sync_Json.dart';
import 'package:nextapp/A_SQL_Trigger/sql_contact.dart';
import 'package:nextapp/A_SQL_Trigger/sql_devicesession.dart';
import 'package:nextapp/A_SQL_Trigger/sql_main_messages.dart';
import 'package:nextapp/A_SQL_Trigger/sql_usermast.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/mdi_page/chat_mdi_page.dart';
import 'package:permission_handler/permission_handler.dart';

import '../A_Local_DB/Sync_Database.dart';
import '../Constant/Con_Wid.dart';

class DownloadData extends StatefulWidget {
  const DownloadData({Key? key}) : super(key: key);
  static List<int> respones = [];
  static List<dynamic> Keyvalue = [];

  @override
  _DownloadData createState() => _DownloadData();
}

class _DownloadData extends State<DownloadData> with TickerProviderStateMixin {
  bool animation = false;
  List<int> comapare = [200, 200, 200, 200, 200, 200, 200, 200, 200, 200];

  @override
  void initState() {
    super.initState();
    Permissionget();
  }

  Permissionget() async {
    var statuses = await [
      Permission.contacts,
      Permission.storage,
    ].request().then((value) => GetData());
  }

  GetData() {
    loadApis().then((value) {
      Future.delayed(const Duration(seconds: 5)).then((value) {
        setState(() {
          bool Comparistion = listEquals(DownloadData.respones, comapare);
          if (Comparistion) {
            animation = true;
          }
        });
      });
    });
  }

  Future loadApis() async {
    await sql_usermast_tran.SelectUserTable();
    await sql_contact_tran.SaveContactDetail();
    await sql_devicesession_tran.setDeviceSession();
    await SyncJSon.user_contact_select_contacts_stream();
    await sql_devicesession_tran.setLoginSessionDetails(true);
    await sql_main_messages_tran.UpdateDeliveryDataMain();
    await sql_usermast_tran.mSetUserOnlineOffline(true);
    await SyncJSon.user_contact_select_fav_stream();
    await SyncDB.SyncTableAuto(true);
    await SyncDB.SyncAllTable(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          getPlatformBrightness() ? DarkTheme_Main : LightTheme_White,
      // appBar: AppBar(
      //   backgroundColor:
      //       getPlatformBrightness() ? DarkTheme_Main : LightTheme_White,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Own_ArrowBack,
      //     color: getPlatformBrightness() ? Con_white : Con_black,
      //     splashRadius: 20,
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 4,
              child: Stack(
                children: [
                  // Image.asset(
                  //   animation
                  //       ? 'assets/images/Donw_Back_Done.webp'
                  //       : 'assets/images/Donw_Back_Wait.webp',
                  //   width: double.infinity,
                  //   fit: BoxFit.fill,
                  // ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: animation
                        ? Image.asset(
                            'assets/images/Donw_Back_Done.webp',
                            key: const Key('DoneImage'),
                            // Use a key to differentiate the images
                            width: double.infinity,
                            fit: BoxFit.fill,
                            color: Con_Main_1,
                          )
                        : Image.asset(
                            'assets/images/Donw_Back_Wait.webp',
                            key: const Key('WaitImage'),
                            // Use a key to differentiate the images
                            width: double.infinity,
                            fit: BoxFit.fill,
                            color: getPlatformBrightness()
                                ? Dark_Wait_Button
                                : null,
                          ),
                  ),
                  Positioned(
                      bottom: 0,
                      top: 180,
                      right: MediaQuery.of(context).size.width / 3,
                      left: MediaQuery.of(context).size.width / 3,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          height: 200,
                          width: 200,
                          key: UniqueKey(),
                          decoration: BoxDecoration(
                            color: getPlatformBrightness()
                                ? DarkTheme_Main
                                : LightTheme_White,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            animation
                                ? 'assets/images/double-check.gif'
                                : 'assets/images/transfer.gif',
                            color: getPlatformBrightness()
                                ? Con_white
                                : Con_Main_1,
                          ),
                        ),
                      )
                      // Container(
                      //   height: 200,
                      //   width: 200,
                      //   decoration: BoxDecoration(
                      //       image: DecorationImage(
                      //           image: animation
                      //               ? const AssetImage(
                      //               'assets/images/double-check.gif')
                      //               : const AssetImage(
                      //               'assets/images/transfer.gif'),
                      //           colorFilter: const ColorFilter.mode(
                      //               Light_Read_Tick, BlendMode.color)),
                      //       color: Colors.white,
                      //       shape: BoxShape.circle),
                      // )
                      ),
                ],
              )),
          Text.rich(
            TextSpan(
              text: animation ? 'Done!' : 'Please Wait...',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              text: animation
                  ? 'Your Data Fetching Done From Server To Your Phone'
                  : 'While We Are Fetching Your Data From Server',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          // Expanded(child: SvgPicture.asset('assets/images/Donw_Back_Done.svg')),
          // Expanded(
          //   child: ListView(
          //     shrinkWrap: true,
          //     children: <Widget>[
          //       Padding(
          //         padding: const EdgeInsets.only(left: 15.0),
          //         child: Text.rich(
          //           TextSpan(
          //             style: const TextStyle(
          //               fontSize: 30,
          //               height: 1.3333333333333333,
          //             ),
          //             children: [
          //
          //                   ? const TextSpan(
          //                       text: 'Done...',
          //                       style: TextStyle(
          //                         fontWeight: FontWeight.w700,
          //                       ),
          //                     )
          //                   : const TextSpan(
          //                       text: 'Please wait...',
          //                       style: TextStyle(
          //                         fontWeight: FontWeight.w700,
          //                       ),
          //                     ),
          //             ],
          //           ),
          //           textHeightBehavior: const TextHeightBehavior(
          //               applyHeightToFirstAscent: false),
          //           textAlign: TextAlign.left,
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(top: 5, left: 15.0),
          //         child: Text.rich(
          //           TextSpan(
          //             style: const TextStyle(
          //               fontSize: 15,
          //               height: 1.3333333333333333,
          //             ),
          //             children: [
          //               animation
          //                   ? TextSpan(
          //                       text:
          //                           'Your Data Fetching Done From Server To Your Phone',
          //                       style: TextStyle(
          //                         fontSize: 14,
          //                         color: getPlatformBrightness()
          //                             ? Dark_AppGreyColor
          //                             : AppGreyColor,
          //                         height: 1.7857142857142858,
          //                       ),
          //                     )
          //                   : TextSpan(
          //                       text:
          //                           'While We Are Fetching Your Data From Server',
          //                       style: TextStyle(
          //                         fontSize: 14,
          //                         color: getPlatformBrightness()
          //                             ? Dark_AppGreyColor
          //                             : AppGreyColor,
          //                         height: 1.7857142857142858,
          //                       ),
          //                     ),
          //             ],
          //           ),
          //           textHeightBehavior: const TextHeightBehavior(
          //               applyHeightToFirstAscent: false),
          //           textAlign: TextAlign.left,
          //         ),
          //       ),
          //     ].toList(),
          //   ),
          // ),
          // Center(
          //   child: SizedBox(
          //     height: 135,
          //     width: MediaQuery.of(context).size.width,
          //     child: animation == false
          //         ? Image.asset("assets/images/Download indicator.gif")
          //         : const Icon(
          //             Icons.check_circle,
          //             color: Con_Main_1,
          //             size: 60,
          //           ),
          //   ),
          // ),
          const Expanded(
            flex: 5,
            child: SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: animation == true
                  ? GestureDetector(
                      onTap: () async {
                        await SharedPref.save_bool('is_login', true);
                        Navigator.pushAndRemoveUntil(
                          context,
                          RouteTransitions.slideTransition(MdiMainPage()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: const Button(),
                    )
                  : const wait(),
            ),
          )
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 150,
        height: 45,
        child: const Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            'Log in',
            style: TextStyle(
              fontSize: 16,
              color: Con_white,
              height: 1.25,
            ),
            textHeightBehavior:
                TextHeightBehavior(applyHeightToFirstAscent: false),
            textAlign: TextAlign.center,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200.0),
          color: Con_Main_1,
          boxShadow: const [
            BoxShadow(
              color: Con_Clr_App_2,
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}

class wait extends StatelessWidget {
  const wait({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 150,
        height: 45,
        child: const Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            'Please wait ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF979797),
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200.0),
          color: getPlatformBrightness() ? Dark_Wait_Button : Color(0xFFEBF0F0),
          boxShadow: const [
            BoxShadow(
              color: Con_Clr_App_2,
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}
