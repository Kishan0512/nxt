import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nextapp/A_FB_Trigger/sql_user_broadcast.dart';
import 'package:nextapp/A_SQL_Trigger/sql_broadcat.dart';
import 'package:nextapp/Constant/Con_AppBar_ChatProfile.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Constant/Con_Wid.dart';
import 'package:nextapp/Constant/Constants.dart';
import 'package:nextapp/Emoji/emoji_widget.dart';
import 'package:path/path.dart' as Path;

import '../../A_FB_Trigger/sql_need_contact.dart';
import '../../A_Local_DB/Sync_Json.dart';
import '../../Constant/Con_Profile_Get.dart';
import '../../OSFind.dart';
import '../chat_mdi_page.dart';

class Con_Broadcast extends StatefulWidget {
  late String id;
  late String name;
  late String image;
  late bool is_show;
  late List broad_splitList;
  late String br_exist_user;

  Con_Broadcast(this.id, this.name, this.image, this.is_show,
      this.broad_splitList, this.br_exist_user,
      {Key? key})
      : super(key: key);

  @override
  _Con_Broadcast createState() => _Con_Broadcast();
}

enum PopUpData { Search, AddName }

class _Con_Broadcast extends State<Con_Broadcast> {
  _Con_Broadcast();

  List<Need_Contact> _needs = [];
  List broad_splitList = [];
  bool _BlnSelectAll = false,
      isSearching = false,
      _blnProgress = false,
      Emojishow = false;
  String mStrRandomId = "", pStrDownloadUrl = "", mStrBroadCastName = "";
  late File _image;
  final picker = ImagePicker();
  final TextEditingController _searchQuery = TextEditingController();
  List<Need_Broadcast> needs = [];

  @override
  void initState() {
    super.initState();
    _setupNeeds();
    setState(() {
      mStrBroadCastName = widget.name;
      broad_splitList = widget.br_exist_user.toString().split(',').toList();
      bindbroaddata();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchQuery.clear();
  }

  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        if (mounted) {
          setState(() {
            _needs = Constants_List.need_contact;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isSearching = true;
            _setupNeeds();
          });
        }
      }
    });
  }

  Future<List<Need_Contact>> _setupNeeds() async {
    if (_searchQuery.text.isEmpty) {
      Constants_List.need_contact =
          (await SyncJSon.user_contact_select_contacts(0));
      if (mounted) {
        setState(() {
          _needs = Constants_List.need_contact;
        });
      }
    } else {
      _needs = Constants_List.need_contact
          .where((element) =>
              element.name
                  .toLowerCase()
                  .toString()
                  .contains(_searchQuery.text.toLowerCase().toString()) ||
              element.mobile_number
                  .toLowerCase()
                  .toString()
                  .contains(_searchQuery.text.toLowerCase().toString()) ||
              element.user_bio
                  .toLowerCase()
                  .toString()
                  .contains(_searchQuery.text.toLowerCase().toString()))
          .toList();
      if (mounted) {
        setState(() {});
      }
    }
    broad_splitList = widget.br_exist_user.toString().split(',').toList();
    bindbroaddata();
    return _needs;
  }

  void bindbroaddata() {
    setState(() {
      for (var e in _needs) {
        var contain = widget.broad_splitList.where(
            (element) => element.toString() == e.user_mast_id.toString());

        if (contain.isNotEmpty) {
          e.is_broadcast = true;
        } else {
          e.is_broadcast = false;
        }
      }
    });
  }

  AppBar SearchAppBar(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double yourWidth = width / 6;
    return AppBar(
      titleSpacing: -2,
      leadingWidth: 48,
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
      title: TextField(
        autofocus: true,
        style: const TextStyle(color: Con_white),
        keyboardType: TextInputType.text,
        controller: _searchQuery,
        onChanged: (value) {
          setState(() {
            _SearchListState();
            isSearching = true;
          });
        },
        decoration: const InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: "Search.."),
      ),
      actions: <Widget>[
        isSearching
            ? Con_Wid.mIconButton(
                icon: Own_Delete_Search,
                onPressed: () {
                  setState(() {
                    _searchQuery.text = "";
                    _SearchListState();
                    _setupNeeds();
                  });
                },
              )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Os.isIOS
        ? Scaffold(
            appBar: isSearching == true
                ? SearchAppBar(context)
                : AppBar(
                    automaticallyImplyLeading: false,
                    leading: Con_Wid.mIconButton(
                      icon: Own_ArrowBack,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: isSearching
                        ? TextField(
                            autofocus: true,
                            controller: _searchQuery,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setState(() {
                                _SearchListState();
                              });
                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "Search.."),
                          )
                        : (widget.id == ""
                            ? Con_Wid.mAppBar("New Broadcast")
                            : Con_Wid.mAppBar("Edit Broadcast")),
                    actions: <Widget>[
                      PopupMenuButton<PopUpData>(
                        splashRadius: 20,
                        onSelected: (PopUpData result) {
                          setState(() {
                            switch (result) {
                              case PopUpData.Search:
                                setState(() {
                                  isSearching = true;
                                });
                                break;
                              case PopUpData.AddName:
                                UpdateBroadCastName();
                                break;
                            }
                          });
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<PopUpData>>[
                          const PopupMenuItem<PopUpData>(
                              value: PopUpData.Search, child: Text('Search')),
                          PopupMenuItem<PopUpData>(
                              value: PopUpData.AddName,
                              child: Text(mStrBroadCastName.toString().isEmpty
                                  ? 'Add name'
                                  : 'Edit name')),
                        ],
                      ),
                    ],
                  ),
            floatingActionButton: FloatingActionButton(
                heroTag: '2',
                backgroundColor: App_Float_Back_Color,
                elevation: 0.0,
                child: const Icon(Icons.check),
                onPressed: () async {
                  int pTrueCount = 0;
                  if (_needs.isNotEmpty) {
                    for (var i = 0; i < _needs.length; i++) {
                      {
                        if (_needs[i].id.toString().isNotEmpty) {
                          if (_needs[i].is_broadcast) {
                            pTrueCount++;
                          }
                        }
                      }
                    }
                  }
                  if (pTrueCount < 2) {
                    Fluttertoast.showToast(
                      msg: 'Please select atleast two contacts',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                    return;
                  }
                  if (mStrBroadCastName == '') {
                    Fluttertoast.showToast(
                      msg: 'Please enter broadcast name',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                    return;
                  }
                  await sql_broadcast_tran.SaveBroadCastDetail(
                      mStrBroadCastName,
                      pStrDownloadUrl,
                      widget.id == "" ? 'INSERT' : 'UPDATE',
                      widget.id,
                      _needs);
                  int count = 0;

                  setState(() {});
                  // Navigator.pop(context);
                  Navigator.pushReplacement(context, RouteTransitions.slideTransition( MdiMainPage(
                        tabindex: 2,
                      )
                  ));
                  // Navigator.of(context).popUntil((_) => count++ >= 2);
                }),
            body: Container(
              color: Con_Clr_App_4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // margin: const EdgeInsets.only(bottom: 7),
                    // decoration:
                    //     const BoxDecoration(
                    //       color: Con_black,
                    //          boxShadow: [
                    //    BoxShadow(
                    //      color: Light_Divider_Shadow,
                    //      blurStyle: BlurStyle.outer,
                    //      blurRadius: 1,
                    //    ),
                    //    BoxShadow(color: Con_white, offset: Offset(0, -5)),
                    //  ]
                    //     ),
                    child: Container(
                      color: getPlatformBrightness()
                          ? DarkTheme_Main
                          : LightTheme_White,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: SizedBox(
                            height: 170.0,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Stack(
                                  fit: StackFit.loose,
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(100),
                                      onTap: () {
                                        _showDrawer_documents_pic();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        height: 135,
                                        width: 135,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 2,
                                                color: Con_Clr_App_7)),
                                        child: _blnProgress == true
                                            ? Container(
                                                width: 120.0,
                                                height: 120.0,
                                                child: const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  color: Con_Main_1,
                                                )),
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Con_white,
                                                ))
                                            : Con_profile_get(
                                                pStrImageUrl: widget.image,
                                                Size: 120,
                                                selected: false,
                                                isbroadcast: true),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: Baseline(
                                        baselineType: TextBaseline.alphabetic,
                                        baseline: 120,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Con_white,
                                          ),
                                          padding: const EdgeInsets.all(3),
                                          height: 40,
                                          width: 40,
                                          child: Container(
                                            height: 35,
                                            width: 35,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: FloatingActionButton(
                                              heroTag: '1',
                                              backgroundColor: Con_Main_1,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                Radius.circular(30.0),
                                              )),
                                              onPressed: () {
                                                _showDrawer_documents_pic();
                                              },
                                              child: widget.image
                                                      .toString()
                                                      .isNotEmpty
                                                  ? const Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                      color: Con_white,
                                                    )
                                                  : const Icon(
                                                      Icons.camera_alt,
                                                      size: 20,
                                                      color: Con_white,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            UpdateBroadCastName();
                          },
                          child: Container(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Text(
                              mStrBroadCastName.isEmpty
                                  ? "Broadcast Name"
                                  : mStrBroadCastName,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 23,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        widget.br_exist_user.isNotEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (_needs
                                                .where((element) =>
                                                    element.is_broadcast ==
                                                    true)
                                                .length)
                                            .toString() +
                                        " of " +
                                        (_needs
                                                .where((element) =>
                                                    element.id != "")
                                                .length)
                                            .toString() +
                                        " Selected ",
                                    style: const TextStyle(fontSize: 15),
                                  )
                                ],
                              )
                            : Container(),
                        widget.br_exist_user.isNotEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: SizedBox(
                                  height: 15,
                                ),
                              )
                            : Container(),
                      ]),
                    ),
                  ),
                  Container(
                    color: getPlatformBrightness()
                        ? DarkTheme_Main
                        : LightTheme_White,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Contacts"
                                    " (" +
                                (_needs
                                        .where((element) => element.id != "")
                                        .length)
                                    .toString() +
                                ")",style: TextStyle(color: Con_msg_auto_6,fontFamily: "Inter",fontWeight: FontWeight.w600)),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 5.0, right: 17.0),
                            child: Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                checkColor: Con_white,
                                shape: const CircleBorder(),
                                value: _BlnSelectAll,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _BlnSelectAll = value!;
                                    if (_needs.isNotEmpty) {
                                      for (var i = 0; i < _needs.length; ++i) {
                                        _needs[i].is_broadcast = _BlnSelectAll;
                                      }
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: getPlatformBrightness()
                          ? DarkTheme_Main
                          : LightTheme_White,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _needs.length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == _needs.length) {
                                  return const SizedBox(height: 66);
                                } else {
                                  Need_Contact need = _needs[index];
                                  return ListTile(
                                    dense: true,
                                    onTap: () {
                                      setState(() {
                                        _needs[index].is_broadcast =
                                            (_needs[index].is_broadcast == true
                                                ? false
                                                : true);
                                      });
                                    },
                                    leading: Con_profile_get(
                                      pStrImageUrl: need.user_profileimage_path,
                                      Size: 45,
                                    ),
                                    title: need.name != " "
                                        ? Text(
                                            need.name,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),
                                          )
                                        : const Text(""),
                                    subtitle: need.id != ""
                                        ? Text(
                                            need.user_bio,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                                fontSize: Constants_Fonts
                                                    .mGblFontSubTitleSize,
                                                color: getPlatformBrightness()
                                                    ? Dark_AppGreyColor
                                                    : AppGreyColor,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : const Text(""),
                                    trailing: need.id != ""
                                        ? Transform.scale(
                                            scale: 1.3,
                                            child: Checkbox(
                                              checkColor: Con_white,
                                              shape: const CircleBorder(),
                                              value: _needs[index].is_broadcast,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  _needs[index].is_broadcast =
                                                      value!;
                                                });
                                              },
                                            ),
                                          )
                                        : const Text(""),
                                  );
                                }
                              })),
                    ),
                  ),
                ],
              ),
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
                middle: widget.id == ""
                    ? const Text(
                        "New Broadcast",
                        style: TextStyle(color: Con_white),
                      )
                    : const Text(
                        "Edit Broadcast",
                        style: TextStyle(color: Con_white),
                      )),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoSearchTextField(
                          controller: _searchQuery,
                          onChanged: (value) {
                            setState(() {
                              _SearchListState();
                            });
                          }),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 7),
                      decoration:
                          const BoxDecoration(color: Con_black, boxShadow: [
                        BoxShadow(
                          color: Light_Divider_Shadow,
                          blurStyle: BlurStyle.outer,
                          blurRadius: 1,
                        ),
                        BoxShadow(color: Con_white, offset: Offset(0, -5)),
                      ]),
                      child: Container(
                        color: getPlatformBrightness()
                            ? DarkTheme_Main
                            : LightTheme_White,
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: SizedBox(
                              height: 170.0,
                              child: Column(
                                children: <Widget>[
                                  Stack(fit: StackFit.loose, children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: GestureDetector(
                                        onTap: () {
                                          Cupertino_showDrawer_documents();
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              height: 135,
                                              width: 135,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      width: 2,
                                                      color: const Color(
                                                          0xff50a6bc))),
                                              child: _blnProgress == true
                                                  ? Container(
                                                      width: 120.0,
                                                      height: 120.0,
                                                      child: const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                        color: Con_Main_1,
                                                      )),
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Con_white,
                                                      ))
                                                  : Con_profile_get(
                                                      pStrImageUrl:
                                                          widget.image,
                                                      Size: 120,
                                                      selected: false,
                                                      isbroadcast: true),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 100, right: 120),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Con_white,
                                              ),
                                              padding: const EdgeInsets.all(3),
                                              height: 40,
                                              width: 40,
                                              child: Container(
                                                height: 35,
                                                width: 35,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: FloatingActionButton(
                                                  heroTag: '1',
                                                  backgroundColor: Con_Main_1,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                    Radius.circular(30.0),
                                                  )),
                                                  onPressed: () {
                                                    Cupertino_showDrawer_documents();
                                                  },
                                                  child: widget.image
                                                          .toString()
                                                          .isNotEmpty
                                                      ? const Icon(
                                                          Icons.edit,
                                                          size: 20,
                                                          color: Con_white,
                                                        )
                                                      : const Icon(
                                                          Icons.camera_alt,
                                                          size: 20,
                                                          color: Con_white,
                                                        ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                  ])
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              UpdateBroadCastName();
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: Material(
                                color: Con_transparent,
                                child: Text(
                                  mStrBroadCastName.isEmpty
                                      ? "Broadcast Name"
                                      : mStrBroadCastName,
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  style: const TextStyle(
                                    fontSize: 23,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          widget.br_exist_user.isNotEmpty
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (_needs
                                                  .where((element) =>
                                                      element.is_broadcast ==
                                                      true)
                                                  .length)
                                              .toString() +
                                          " of " +
                                          (_needs
                                                  .where((element) =>
                                                      element.id != "")
                                                  .length)
                                              .toString() +
                                          " Selected ",
                                      style: const TextStyle(fontSize: 15),
                                    )
                                  ],
                                )
                              : Container(),
                          widget.br_exist_user.isNotEmpty
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: SizedBox(
                                    height: 15,
                                  ),
                                )
                              : Container(),
                        ]),
                      ),
                    ),
                    Container(
                      color: getPlatformBrightness()
                          ? DarkTheme_Main
                          : LightTheme_White,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              color: Con_transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Contacts"
                                        " (" +
                                    (_needs
                                            .where(
                                                (element) => element.id != "")
                                            .length)
                                        .toString() +
                                    ")"),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, right: 13.0),
                              child: Transform.scale(
                                scale: 1.3,
                                child: Material(
                                  color: Con_transparent,
                                  child: Checkbox(
                                    checkColor: Con_white,
                                    shape: const CircleBorder(),
                                    value: _BlnSelectAll,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _BlnSelectAll = value!;
                                        if (_needs.isNotEmpty) {
                                          for (var i = 0;
                                              i < _needs.length;
                                              ++i) {
                                            _needs[i].is_broadcast =
                                                _BlnSelectAll;
                                          }
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: getPlatformBrightness()
                            ? DarkTheme_Main
                            : LightTheme_White,
                        child: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: ListView.builder(
                                itemCount: _needs.length + 1,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == _needs.length) {
                                    return const SizedBox(height: 66);
                                  } else {
                                    Need_Contact need = _needs[index];
                                    return CupertinoListTile(
                                      onTap: () {
                                        setState(() {
                                          _needs[index].is_broadcast =
                                              (_needs[index].is_broadcast ==
                                                      true
                                                  ? false
                                                  : true);
                                        });
                                      },
                                      leading: Con_profile_get(
                                        pStrImageUrl:
                                            need.user_profileimage_path,
                                        Size: 45,
                                      ),
                                      title: need.name != " "
                                          ? Text(
                                              need.name,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            )
                                          : const Text(""),
                                      subtitle: need.id != ""
                                          ? Text(
                                              need.user_bio,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: Constants_Fonts
                                                      .mGblFontSubTitleSize,
                                                  color: getPlatformBrightness()
                                                      ? Dark_AppGreyColor
                                                      : AppGreyColor,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : const Text(""),
                                      trailing: need.id != ""
                                          ? Transform.scale(
                                              scale: 1.3,
                                              child: Material(
                                                color: Con_transparent,
                                                child: Checkbox(
                                                  checkColor: Con_white,
                                                  shape: const CircleBorder(),
                                                  value: _needs[index]
                                                      .is_broadcast,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      _needs[index]
                                                              .is_broadcast =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                            )
                                          : const Text(""),
                                    );
                                  }
                                })),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoButton(
                      borderRadius: BorderRadius.circular(30),
                      padding: EdgeInsets.zero,
                      color: App_IconColor,
                      child: const Icon(Icons.check),
                      onPressed: () async {
                        int pTrueCount = 0;
                        if (_needs.isNotEmpty) {
                          for (var i = 0; i < _needs.length; i++) {
                            {
                              if (_needs[i].id.toString().isNotEmpty) {
                                if (_needs[i].is_broadcast) {
                                  pTrueCount++;
                                }
                              }
                            }
                          }
                        }
                        if (pTrueCount < 2) {
                          Fluttertoast.showToast(
                            msg: 'Please select atleast two contacts',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          return;
                        }
                        if (mStrBroadCastName == '') {
                          Fluttertoast.showToast(
                            msg: 'Please enter broadcast name',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          return;
                        }
                        await sql_broadcast_tran.SaveBroadCastDetail(
                            mStrBroadCastName,
                            pStrDownloadUrl,
                            widget.id == "" ? 'INSERT' : 'UPDATE',
                            widget.id,
                            _needs);
                        int count = 0;
                        // Navigator.push(context, MaterialPageRoute(builder: (context) {
                        //   return MdiMainPage();
                        // },));
                        setState(() {});
                        Navigator.pop(context);
                        // Navigator.of(context).popUntil((_) => count++ >= 2);
                      }),
                )
              ],
            ));
  }

  Future<void> UpdateBroadCastName() async {
    final result = await Navigator.push(
      context,
      RouteTransitions.slideTransition(
              Con_Broadcast_TextField(widget.id, mStrBroadCastName)),
    );
    if (result != null) {
      {
        widget.name = result.toString();
        mStrBroadCastName = result.toString();
      }
      setState(() {});
    }
  }

  Cupertino_showDrawer_documents() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text("Profile Setting", style: TextStyle(fontSize: 20)),
          cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel")),
          actions: [
            CupertinoActionSheetAction(
                onPressed: () {
                  setState(() {
                    widget.image = "";
                  });
                  Navigator.pop(context);
                },
                child: const Text("Remove Profile Picture")),
            CupertinoActionSheetAction(
                onPressed: () {
                  getImage();
                  Navigator.pop(context);
                },
                child: const Text("Select Profile Picture")),
            CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  var pControllerName;
                  Navigator.push(
                      context,
                      RouteTransitions.slideTransition( sub_show_profile_details(
                              widget.id,
                              pControllerName.text
                                  .toString()
                                  .trim()
                                  .trimLeft()
                                  .trimRight(),
                              widget.image != ""
                                  ? widget.image
                                  : Constants_Usermast
                                      .user_broadimage_path_global)));
                },
                child: const Text("View Profile Picture")),
          ],
        );
      },
    );
  }

  _showDrawer_documents_pic() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              color: const Color(0xFF737373),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Center(
                        child: Container(
                            width: 30,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: App_DrawerDocumentColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            )),
                      ),
                    ),
                    ListTile(
                      leading:
                          getPlatformBrightness() ? Dark_Remove : Own_Remove,
                      title: const Text('Remove Profile Picture'),
                      onTap: () {
                        setState(() {
                          widget.image = "";
                          DeleteFromLocal();
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: getPlatformBrightness()
                          ? Dark_Pic_SelectProfile
                          : Own_Pic_SelectProfile,
                      title: const Text('Select Profile Picture'),
                      onTap: () {
                        getImage();
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: getPlatformBrightness()
                          ? Dark_Pic_ViewProfile
                          : Own_Pic_ViewProfile,
                      title: const Text('View Profile Picture'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            RouteTransitions.slideTransition( sub_show_profile_details(
                                    widget.id,
                                    mStrBroadCastName,
                                    widget.image != ""
                                        ? widget.image
                                        : Constants_Usermast
                                            .user_broadimage_path_global)));
                      },
                    )
                  ],
                ),
              ));
        });
  }

  DeleteFromLocal() async {
    File file = File(
        '${Constants_Usermast.dbpath!.path.toString()}/Image/Profile/br_${Constants_Usermast.user_id}.png');
    if (await file.exists()) {
      setState(() {
        file.delete();
      });
    }
  }

  Future getImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = File(pickedFile!.path);
      _blnProgress = true;
    });
    firebase_storage.Reference storageReference =
        firebase_storage.FirebaseStorage.instance.ref().child(
            'user_group_pictures/${widget.id}/${Path.basename(_image.path)}');
    firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);
    uploadTask.whenComplete(() => 'print');
    var dowurl =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();

    setState(() {
      {
        pStrDownloadUrl = dowurl.toString();
        _blnProgress = false;
        widget.image = pStrDownloadUrl;
      }
    });
  }
}

class Con_Broadcast_TextField extends StatefulWidget {
  String id = '', name = '';

  Con_Broadcast_TextField(this.id, this.name, {super.key});

  @override
  State<Con_Broadcast_TextField> createState() =>
      _Con_Broadcast_TextFieldState();
}

class _Con_Broadcast_TextFieldState extends State<Con_Broadcast_TextField> {
  FocusNode gfgFocusNode = FocusNode();
  final pControllerName = TextEditingController();
  bool Emojishow = false;

  @override
  void initState() {
    super.initState();
    if (widget.name.toString().trim().trimRight() != "") {
      pControllerName.text = widget.name.toString().trim().trimRight();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Os.isIOS? Scaffold(
      floatingActionButton: FloatingActionButton(
          heroTag: '2',
          backgroundColor: App_Float_Back_Color,
          elevation: 0.0,
          child: const Icon(Icons.check),
          onPressed: () async {
            if (pControllerName.text.trim().trimLeft().trimRight() == "") {
              Fluttertoast.showToast(
                msg: 'Please enter broadcast name',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
              return;
            } else {
              var pStrBrName =
                  pControllerName.text.toString().trim().trimLeft().trimRight();
              sql_broadcast_tran.SetBroadcastMain(widget.id, pStrBrName);
              Navigator.of(context).pop(pStrBrName);
            }
          }),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Con_Wid.mIconButton(
          icon: Own_ArrowBack,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: widget.id == ""
            ? Con_Wid.mAppBar("Broadcast Name")
            : Con_Wid.mAppBar("Broadcast Name"),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 45),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () => gfgFocusNode.requestFocus(),
                        child: TextFormField(
                          focusNode: gfgFocusNode,
                          controller: pControllerName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter broadcast name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Broadcast Name',
                            hintStyle: TextStyle(fontSize: 17),
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 25,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.4285714285714286,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 5,
                right: 1,
                child: Con_Wid.mIconButton(
                  icon: Icon(Own_Face,
                      color: Emojishow == true ? AppBar_ThemeColor : null),
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {});
                    await Future.delayed(const Duration(milliseconds: 50));
                    Emojishow = !Emojishow;
                    setState(() {});
                    showModalBottomSheet(
                      barrierColor: Con_transparent,
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 255,
                          child: Emoji_Widget(controller: pControllerName),
                        );
                      },
                    );
                  },
                  color: AppBlueGreyColor2,
                ),
              ),
            ],
          ),
        ),
      ]),
    ):CupertinoPageScaffold(
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
            middle: widget.id == ""
                ? Text("Broadcast Name",style: TextStyle(color: Con_white),)
                :Text("Broadcast Name",style: TextStyle(color: Con_white),)),
        child: Material(
          color: Colors.transparent,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10,right: 45),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () => gfgFocusNode.requestFocus(),
                            child: CupertinoTextField(
                              focusNode: gfgFocusNode,
                              controller: pControllerName,
                              placeholder: "Broadcast Name",
                              keyboardType: TextInputType.text,
                              maxLength: 25,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.4285714285714286,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 1,
                    child: Con_Wid.mIconButton(
                      icon: Icon(Own_Face,
                          color: Emojishow == true ? AppBar_ThemeColor : null),
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {});
                        await Future.delayed(const Duration(milliseconds: 50));
                        Emojishow = !Emojishow;
                        setState(() {});
                        showModalBottomSheet(
                          barrierColor: Con_transparent,
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: 255,
                              child: Emoji_Widget(controller: pControllerName),
                            );
                          },
                        );
                      },
                      color: AppBlueGreyColor2,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
