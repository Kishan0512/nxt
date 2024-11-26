import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextapp/A_SQL_Trigger/sql_sub_messages.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Constants.dart';

import '../../Constant/Con_Clr.dart';
import '../../Constant/Con_Usermast.dart';
import '../../Constant/Con_Wid.dart';
import '../../OSFind.dart';
import '../chat_mdi_page.dart';

typedef SetStateFunction = void Function(VoidCallback callback);

class MsgMediaList extends StatefulWidget {
  final String pStrMobileNumber, pStrUserName, usermastid;
  final List imageList, videolist, audiolist, doculist;

  const MsgMediaList(this.pStrMobileNumber, this.pStrUserName, this.usermastid,
      this.imageList, this.videolist, this.audiolist, this.doculist,
      {Key? key})
      : super(key: key);

  @override
  _MsgMediaList createState() => _MsgMediaList();
}

class _MsgMediaList extends State<MsgMediaList> {
  int _currentIndex = 0, pIntListCounter = 0;
  final primaryColor = const Color(0xff203152);
  final greyColor2 = const Color(0xffE8E8E8);
  bool isSelected = false, isExist = false;
  List<String> mListSelected_id1 = [];
  List mListSelected_id = [];

  @override
  Widget build(BuildContext context) {
    return Os.isIOS
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: true,
              iconTheme: const IconThemeData(color: Con_white),
              actionsIconTheme: const IconThemeData(color: Con_white),
              leading: Con_Wid.mIconButton(
                icon: Own_ArrowBack,
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              title: isSelected
                  ? Text("${mListSelected_id.length} Selected")
                  : Constants.mAppBar('Media List'),
              actions: isSelected
                  ? [
                      if (mListSelected_id.isNotEmpty)
                        Con_Wid.mIconButton(
                            onPressed: () {
                              switch (_currentIndex) {
                                case 0:
                                  setState(() {
                                    isSelected = false;
                                    for (var e in mListSelected_id) {
                                      widget.imageList
                                          .removeWhere((u) => u.id == e.id);
                                    }
                                  });
                                  break;
                                case 1:
                                  widget.videolist;
                                  break;
                                case 2:
                                  widget.audiolist;
                                  break;
                                case 3:
                                  widget.doculist;
                                  break;
                              }
                              var fromIds = mListSelected_id
                                  .where((e) =>
                                      e.msg_from_user_mast_id ==
                                      Constants_Usermast.user_mast_id)
                                  .map((e) => e.id.trim())
                                  .join(",");

                              var toIds = mListSelected_id
                                  .where((e) =>
                                      e.msg_from_user_mast_id !=
                                      Constants_Usermast.user_mast_id)
                                  .map((e) => e.id.trim())
                                  .join(",");

                              sql_sub_messages_tran.Sub_ChatUserWiseDelete(
                                  Constants_Usermast.user_id,
                                  int.parse(widget.usermastid),
                                  toIds,
                                  fromIds,
                                  false);
                              setState(() {
                                isSelected = false;
                                mListSelected_id.clear();
                              });
                            },
                            icon: Own_Delete_White),
                      Con_Wid.mIconButton(
                          onPressed: () {
                            Navigator.push(context, RouteTransitions.slideTransition(MdiMainPage(
                                    selected_needs_sub_msg: mListSelected_id1)
                            )).then((value) {
                              setState(() {
                                isSelected = false;
                                mListSelected_id.clear();
                              });
                            });
                          },
                          icon: Image.asset(
                            'assets/images/forward.webp',
                          )),
                    ]
                  : [],
            ),
            body: WidgetRedirect(_currentIndex, context, widget.pStrUserName),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Con_black,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                    icon: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset(
                          'assets/images/Gallery_Icon.webp',
                          color: getPlatformBrightness()
                              ? Dark_AppGreyColor
                              : AppGreyColor,
                        )),
                    activeIcon: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset(
                          'assets/images/Gallery_Icon.webp',
                          color: App_Float_Back_Color,
                        )),
                    label: 'Photos'),
                BottomNavigationBarItem(
                    icon: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset('assets/images/Videos_Icon.webp',
                            color: AppGreyColor)),
                    activeIcon: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset(
                          'assets/images/Videos_Icon.webp',
                          color: App_Float_Back_Color,
                        )),
                    label: 'Videos'),
                BottomNavigationBarItem(
                    icon: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset('assets/images/Music_Icon.webp',
                            color: AppGreyColor)),
                    activeIcon: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset(
                          'assets/images/Music_Icon.webp',
                          color: App_Float_Back_Color,
                        )),
                    label: 'Audio'),
                BottomNavigationBarItem(
                    icon: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset('assets/images/Doc_Icon.webp',
                            color: AppGreyColor)),
                    activeIcon: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset(
                          'assets/images/Doc_Icon.webp',
                          color: App_Float_Back_Color,
                        )),
                    label: 'Documents')
              ],
            ))
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                backgroundColor: App_IconColor,
                padding: EdgeInsetsDirectional.zero,
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child:
                      const Icon(CupertinoIcons.left_chevron, color: Con_white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                middle: const Text(
                  "Media List",
                  style: TextStyle(color: Con_white),
                )),
            child: CupertinoTabScaffold(
              tabBar: CupertinoTabBar(
                  backgroundColor: Con_transparent,
                  items: const [
                    BottomNavigationBarItem(
                        label: "Photo",
                        icon: Icon(
                          CupertinoIcons.photo,
                          size: 25,
                        )),
                    BottomNavigationBarItem(
                        label: "Video",
                        icon: Icon(
                          CupertinoIcons.video_camera_solid,
                          size: 30,
                        )),
                    BottomNavigationBarItem(
                        label: "Music",
                        icon: Icon(
                          CupertinoIcons.music_note_2,
                          size: 25,
                        )),
                    BottomNavigationBarItem(
                        label: "Document",
                        icon: Icon(
                          CupertinoIcons.doc_fill,
                          size: 25,
                        ))
                  ]),
              tabBuilder: (context, index) {
                return CupertinoTabView(
                  builder: (context) {
                    return WidgetRedirect(index, context, widget.pStrUserName);
                  },
                );
              },
            ));
  }

  WidgetRedirect(int index, BuildContext context, String pStrUserName) {
    switch (index) {
      case 0:
        return First_Photos(
          widget.imageList,
          "",
          isSelected,
          mListSelected_id,
          (value) {
            setState(() {
              isSelected = value;
              if (!isSelected) {
                value = isSelected;
              }
            });
          },
          (value) {
            setState(() {
              mListSelected_id = value;
              if (!isSelected) {
                value = mListSelected_id;
              }
            });
          },
          pStrUserName,
        );
      case 1:
        return Second_Videos(widget.videolist, isSelected, mListSelected_id1,
            (value) {
          setState(() {
            isSelected = value;
            if (!isSelected) {
              value = isSelected;
            }
          });
        }, (value) {
          setState(() {
            mListSelected_id = value;
            if (!isSelected) {
              value = mListSelected_id1;
            }
          });
        }, pStrUserName);
      case 2:
        return Third_Audio(
          widget.audiolist,
          isSelected,
          mListSelected_id1,
          (value) {
            setState(() {
              isSelected = value;
              if (!isSelected) {
                value = isSelected;
              }
            });
          },
          (value) {
            setState(() {
              mListSelected_id = value;
              if (!isSelected) {
                value = mListSelected_id1;
              }
            });
          },
        );
      case 3:
        return Fourth_Documents(
          widget.doculist,
          isSelected,
          mListSelected_id1,
          (value) {
            setState(() {
              isSelected = value;
              if (!isSelected) {
                value = isSelected;
              }
            });
          },
          (value) {
            setState(() {
              mListSelected_id = value;
              if (!isSelected) {
                value = mListSelected_id1;
              }
            });
          },
        );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      isSelected = false;
      mListSelected_id.clear();
    });
  }
}
