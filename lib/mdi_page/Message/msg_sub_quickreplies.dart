import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextapp/A_Local_DB/Sync_Json.dart';
import 'package:nextapp/A_SQL_Trigger/sql_quickreply.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Constants.dart';

import '../../A_FB_Trigger/sql_need_quickreply.dart';
import '../../Constant/Con_Wid.dart';
import '../../OSFind.dart';

class QuickReplies extends StatefulWidget {
  const QuickReplies({Key? key}) : super(key: key);

  @override
  _QuickReplies createState() => _QuickReplies();
}

class _QuickReplies extends State<QuickReplies> {
  final msgController = TextEditingController();
  bool isSearching = false;
  final TextEditingController _searchQuery = TextEditingController();
  late FocusNode _Focus;
  List<Need_QuickReply> listbind = [];

  @override
  void initState() {
    super.initState();
    _Focus = FocusNode();
    isSearching = false;
  }

  Future<List<Need_QuickReply>> _setupNeeds(bool pBln) async {
    if (_searchQuery.text.isEmpty) {
      await SyncJSon.user_quick_rep_select();
      if (mounted) {
        setState(() {
          listbind = Constants_List.need_quickreply;
        });
      }
    } else {
      listbind = Constants_List.need_quickreply
          .where((element) =>
          element.user_quick_value
              .toLowerCase()
              .toString()
              .contains(_searchQuery.text.toLowerCase().toString()))
          .toList();
      if (mounted) {
        setState(() {});
      }
    }
    return listbind;
  }

  onsubmit() {
    String Value = msgController.text.toString().trim().trimLeft().trimRight();
    if (Value.isEmpty) {
      return;
    }
    sql_quickreply_tran.SetQuickReplyDetail(Value, 0);
    _setupNeeds(true);
    msgController.clear();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _searchQuery.clear();
    _Focus.dispose();
  }

  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() async {
          listbind = Constants_List.need_quickreply;
        });
      } else {
        setState(() {
          isSearching = true;
          _setupNeeds(false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Os.isIOS
        ? Scaffold(
      // backgroundColor:
      // SchedulerBinding.instance.window.platformBrightness == Brightness.dark
      //     ? Con_black
      //     : Con_white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: App_Float_Back_Color,
        onPressed: () async {
          return await showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                    insetPadding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: WidgetsBinding
                          .instance.window.viewInsets.bottom >
                          0.0
                          ? 120
                          : 250,
                    ),
                    child: Column(
                      children: <Widget>[
                        Material(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(3),
                              topRight: Radius.circular(3)),
                          color: Con_Main_1,
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 15, top: 5),
                                      child: const Text("Add quick reply",
                                          style: TextStyle(
                                              color: Con_white,
                                              fontSize: 20))),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height,
                            margin: const EdgeInsets.only(
                                top: 8, left: 7, bottom: 5, right: 7),
                            child: TextField(
                              controller: msgController,
                              maxLines: 8,
                              autofocus: true,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (value) {
                                onsubmit();
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Con_Main_1),
                                    borderRadius:
                                    BorderRadius.circular(10)),
                                hintText: "Enter a quick reply",
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 7.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: OutlinedButton(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  child: OutlinedButton(
                                    child: const Text("Ok"),
                                    onPressed: () async {
                                      onsubmit();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ));
              });
        },
        child: const Icon(
          Icons.add,
          color: AppBar_PrimaryColor,
          size: 29,
        ),
        elevation: 5,
        splashColor: Con_white,
      ),
      appBar: AppBar(
          automaticallyImplyLeading: true,
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
          actions: <Widget>[
            isSearching
                ? _searchQuery.text
                .trim()
                .trimLeft()
                .trimRight()
                .isNotEmpty
                ? Con_Wid.mIconButton(
              icon: Own_Delete_Search,
              onPressed: () {
                setState(() {
                  _searchQuery.text = "";
                  _SearchListState();
                });
              },
            )
                : const Text("")
                : Con_Wid.mIconButton(
              icon: Own_Search,
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
            ),
          ],
          title: isSearching
              ? TextField(
            autofocus: true,
            style: const TextStyle(color: Con_white),
            keyboardType: TextInputType.text,
            controller: _searchQuery,
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
              : Constants.mAppBar('Quick Replies')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
              child: FutureBuilder(
                  future: _setupNeeds(false),
                  builder: (context, snapshot) {
                    return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: listbind.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                              listbind[index].user_quick_value.toString(),
                            ),
                            trailing: Con_Wid.mIconButton(
                              icon: getPlatformBrightness()
                                  ? Dark_Delete
                                  : Own_Delete,
                              onPressed: () {
                                setState(() {
                                  sql_quickreply_tran.DelQuickReplyDetail(
                                      listbind[index].id.toString());
                                  _setupNeeds(true);
                                });
                              },
                            ),
                          );
                        });
                  }))
        ],
      ),
    )
        : CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            padding: EdgeInsetsDirectional.zero,
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.add, color: Con_white),
              onPressed: () async {
                return await showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                          insetPadding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: WidgetsBinding
                                .instance.window.viewInsets.bottom >
                                0.0
                                ? 120
                                : 250,
                          ),
                          child: Column(
                            children: <Widget>[
                              Material(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(3),
                                    topRight: Radius.circular(3)),
                                color: Con_Main_1,
                                child: SizedBox(
                                  height: 50,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 15, top: 5),
                                            child: const Text(
                                                "Add quick reply",
                                                style: TextStyle(
                                                    color: Con_white,
                                                    fontSize: 20))),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height,
                                  margin: const EdgeInsets.only(
                                      top: 8, left: 7, bottom: 5, right: 7),
                                  child: CupertinoTextField(
                                    controller: msgController,
                                    maxLines: 5,
                                    autofocus: true,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (value) {
                                      onsubmit();
                                    },
                                    placeholder: "Enter a quick reply",
                                    decoration: BoxDecoration(
                                        border:
                                        Border.all(color: Con_Main_1),
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 7.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CupertinoButton(
                                      child: const Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    CupertinoButton(
                                      child: const Text("Ok"),
                                      onPressed: () {
                                        onsubmit();
                                      },
                                    ),
                                    // Container(
                                    //   child: OutlinedButton(
                                    //     child: const Text("Cancel"),
                                    //     onPressed: () {
                                    //     },
                                    //   ),
                                    // ),
                                    // const SizedBox(
                                    //   width: 10,
                                    // ),
                                    // Container(
                                    //   child: OutlinedButton(
                                    //     child: const Text("Ok"),
                                    //     onPressed: () async {
                                    //
                                    //     },
                                    //   ),
                                    // )
                                  ],
                                ),
                              )
                            ],
                          ));
                    });
              },
            ),
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child:
              const Icon(CupertinoIcons.left_chevron, color: Con_white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: App_IconColor,
            middle: const Text(
              "Quick Replies",
              style: TextStyle(color: Con_white),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSearchTextField(
                autofocus: false,
                onSubmitted: (value) {
                  FocusScope.of(context).dispose();
                },
                controller: _searchQuery,
                onChanged: (value) {
                  setState(() {
                    _SearchListState();
                  });
                },
              ),
            ),
            Expanded(
                child: FutureBuilder(
                    future: _setupNeeds(false),
                    builder: (context, snapshot) {
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: listbind.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CupertinoListTile(
                              title: Text(
                                listbind[index].user_quick_value.toString(),
                              ),
                              trailing: CupertinoButton(
                                child: getPlatformBrightness()
                                    ? const Icon(CupertinoIcons.delete)
                                    : const Icon(CupertinoIcons.delete),
                                onPressed: () {
                                  setState(() {
                                    sql_quickreply_tran.DelQuickReplyDetail(
                                        listbind[index].id.toString());
                                    _setupNeeds(true);
                                  });
                                },
                              ),
                            );
                          });
                    }))
          ],
        ));
  }
}
