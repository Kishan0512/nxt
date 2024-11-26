import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextapp/A_SQL_Trigger/sql_contact.dart';

import '../A_FB_Trigger/sql_need_contact.dart';
import '../A_Local_DB/Sync_Database.dart';
import '../A_Local_DB/Sync_Json.dart';
import '../Constant/Con_Clr.dart';
import '../Constant/Con_Icons.dart';
import '../Constant/Con_Profile_Get.dart';
import '../Constant/Con_Wid.dart';
import '../Constant/Constants.dart';
import '../OSFind.dart';
import '../mdi_page/chat_mdi_page.dart';

class Con_Global_Contacts extends StatefulWidget {
  late String mStrPage;
  ValueChanged<List<Need_Contact>> Selected;
  List<Need_Contact>? Selected_Contact;

  Con_Global_Contacts(this.mStrPage,
      {Key? key, required this.Selected, this.Selected_Contact})
      : super(key: key);

  @override
  _Con_Global_Contacts createState() => _Con_Global_Contacts(mStrPage);
}

class _Con_Global_Contacts extends State<Con_Global_Contacts> {
  _Con_Global_Contacts(this.mStrPage);

  List<Need_Contact> _needs = [];
  List<Need_Contact> _Selected_Auto = [];
  String mStrPage = "", mStrSetString = "";
  int mIntPage = 0;
  bool _BlnSelectAll = false, isSearching = false;
  final TextEditingController _searchQuery = TextEditingController();

  @override
  void initState() {
    super.initState();
    isSearching = false;
    _Selected_Auto = widget.Selected_Contact ?? _Selected_Auto;
    setState(() {
      if (mStrPage == "Favourite") {
        mStrSetString = "Favourite Contacts";
        mIntPage = 0;
      } else if (mStrPage == "Block") {
        mStrSetString = "Block";
        mIntPage = 1;
      } else if (mStrPage == "Auto") {
        mStrSetString = "Contacts";
        mIntPage = 2;
      }
    });
    _setupNeeds();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _setupNeeds();
        });
      } else {
        setState(() {
          isSearching = true;
          _setupNeeds();
        });
      }
    });
  }

  Future<List<Need_Contact>> _setupNeeds() async {
    List<Need_Contact> firstCon =
        (await SyncJSon.user_contact_select_contacts(0));
    if (firstCon.isNotEmpty) {
      _needs = firstCon;
      setState(() {});
      if (mIntPage == 0) {
        _needs.removeWhere((element) => element.user_is_block == true);
        if (_searchQuery.text.isNotEmpty) {
          _needs = _needs
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
        }
        return _needs;
      } else if (mIntPage == 1) {
        if (_searchQuery.text.isNotEmpty) {
          _needs = _needs
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
        }
        return _needs;
      } else if (mIntPage == 2) {
        setState(() {
          _needs = firstCon;
        });
      }
      return _needs;
    } else {
      _needs = (await SyncJSon.user_contact_select_contacts(0));
      setState(() {});
    }
    return _needs;
  }

  bool parseBool(String pStr) {
    if (pStr == 'true') {
      return true;
    } else if (pStr == 'false') {
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Os.isIOS
        ? Scaffold(
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
                    : Con_Wid.mAppBar(mStrSetString),
                actions: [
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
                                  _setupNeeds();
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
                        )
                ]),
            floatingActionButton: SizedBox(
              height: 50,
              width: 50,
              child: FloatingActionButton(
                  elevation: 0.0,
                  child: Own_Save,
                  onPressed: mStrPage == "Auto"
                      ? () {
                          widget.Selected.call(_Selected_Auto);
                          Navigator.pop(context);
                        }
                      : () async {
                          await sql_contact_tran.SaveContactDetFavBlock(_needs);
                          await SyncDB.SyncTable(
                              Constants.Table_Contacts_user_wise, false);
                          _setupNeeds();
                          Navigator.pushReplacement(
                              context, RouteTransitions.slideTransition(MdiMainPage()));
                        }),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_needs.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Contacts (" +
                              (_needs
                                      .where((element) => element.id != "")
                                      .length)
                                  .toString() +
                              ")",style: TextStyle(color: Con_msg_auto_6,fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 17.0),
                          child: Transform.scale(
                            scale: 1.3,
                            child: Checkbox(
                              value: _BlnSelectAll,
                              onChanged: (bool? value) {
                                setState(() {
                                  _BlnSelectAll = value!;
                                  if (_needs.isNotEmpty) {
                                    for (var i = 0; i < _needs.length; ++i) {
                                      if (mIntPage == 0) {
                                        _needs[i].user_is_favourite =
                                            _BlnSelectAll;
                                      } else if (mIntPage == 1) {
                                        _needs[i].user_is_block = _BlnSelectAll;
                                      } else if (mIntPage == 2) {
                                        if (_BlnSelectAll) {
                                          if (!_Selected_Auto.contains(
                                              _needs[i])) {
                                            setState(() {
                                              _Selected_Auto.add(_needs[i]);
                                            });
                                          }
                                        } else {
                                          if (_Selected_Auto.contains(
                                              _needs[i])) {
                                            setState(() {
                                              _Selected_Auto.remove(_needs[i]);
                                            });
                                          }
                                        }
                                      }
                                    }
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(),
                Expanded(
                  child: RefreshIndicator(
                      onRefresh: () => _setupNeeds(),
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: _needs.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == _needs.length) {
                              return const SizedBox(height: 66);
                            } else {
                              Need_Contact need = _needs[index];
                              return ListTile(
                                  dense: true,
                                  onTap: () {
                                    mIntPage == 0
                                        ? setState(() {
                                            need.user_is_favourite =
                                                need.user_is_favourite
                                                    ? false
                                                    : true;
                                          })
                                        : mIntPage == 2
                                            ? setState(() {
                                                if (!_Selected_Auto.contains(
                                                    _needs[index])) {
                                                  setState(() {
                                                    _Selected_Auto.add(
                                                        _needs[index]);
                                                  });
                                                } else {
                                                  setState(() {
                                                    _Selected_Auto.remove(
                                                        _needs[index]);
                                                  });
                                                }
                                                _BlnSelectAll =
                                                    _Selected_Auto.length ==
                                                            _needs.length
                                                        ? true
                                                        : false;
                                              })
                                            : setState(() {
                                                need.user_is_block =
                                                    need.user_is_block
                                                        ? false
                                                        : true;
                                              });
                                  },
                                  leading: need.id != ""
                                      ? Con_profile_get(
                                          pStrImageUrl:
                                              need.user_profileimage_path,
                                          Size: 45,
                                        )
                                      : const Text(""),
                                  title: Text(
                                    need.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: "Inter"),
                                  ),
                                  subtitle: Text(
                                    need.user_bio,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Con_grey.shade600,
                                        fontFamily: "Inter"),
                                  ),
                                  trailing: mIntPage == 0
                                      ? Transform.scale(
                                          scale: 1.3,
                                          child: Checkbox(

                                            value: parseBool(need
                                                .user_is_favourite
                                                .toString()),
                                            onChanged: (bool? value) {
                                              setState(() {
                                                need.user_is_favourite = value!;
                                              });
                                            },
                                          ),
                                        )
                                      : mIntPage == 2
                                          ? Transform.scale(
                                              scale: 1.3,
                                              child: Checkbox(
                                                value: _Selected_Auto.contains(
                                                    _needs[index]),
                                                onChanged: (bool? value) {
                                                  if (!_Selected_Auto.contains(
                                                      _needs[index])) {
                                                    setState(() {
                                                      _Selected_Auto.add(
                                                          _needs[index]);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _Selected_Auto.remove(
                                                          _needs[index]);
                                                    });
                                                  }
                                                  setState(() {
                                                    _BlnSelectAll =
                                                        _Selected_Auto.length ==
                                                                _needs.length
                                                            ? true
                                                            : false;
                                                  });
                                                },
                                              ),
                                            )
                                          : Transform.scale(
                                              scale: 1.3,
                                              child: Checkbox(
                                                value: parseBool(need
                                                    .user_is_block
                                                    .toString()),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    need.user_is_block = value!;
                                                  });
                                                },
                                              ),
                                            ));
                            }
                          })),
                ),
                //
              ],
            ),
          )
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                padding: EdgeInsetsDirectional.zero,
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child:
                      const Icon(CupertinoIcons.left_chevron, color: Con_white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: App_IconColor,
                middle: Text(
                  mStrSetString,
                  style: const TextStyle(color: Con_white),
                )),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                    if (_needs.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              color: Con_transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Contacts (" +
                                    (_needs
                                            .where(
                                                (element) => element.id != "")
                                            .length)
                                        .toString() +
                                    ")"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: Transform.scale(
                                scale: 1.3,
                                child: Material(
                                  color: Con_transparent,
                                  child: Checkbox(
                                    value: _BlnSelectAll,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _BlnSelectAll = value!;
                                        if (_needs.isNotEmpty) {
                                          for (var i = 0;
                                              i < _needs.length;
                                              ++i) {
                                            if (mIntPage == 0) {
                                              _needs[i].user_is_favourite =
                                                  _BlnSelectAll;
                                            } else if (mIntPage == 1) {
                                              _needs[i].user_is_block =
                                                  _BlnSelectAll;
                                            } else if (mIntPage == 2) {
                                              if (_BlnSelectAll) {
                                                if (!_Selected_Auto.contains(
                                                    _needs[i])) {
                                                  setState(() {
                                                    _Selected_Auto.add(
                                                        _needs[i]);
                                                  });
                                                }
                                              } else {
                                                if (_Selected_Auto.contains(
                                                    _needs[i])) {
                                                  setState(() {
                                                    _Selected_Auto.remove(
                                                        _needs[i]);
                                                  });
                                                }
                                              }
                                            }
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
                      )
                    else
                      Container(),
                    Expanded(
                      child: RefreshIndicator(
                          onRefresh: () => _setupNeeds(),
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: _needs.length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == _needs.length) {
                                  return const SizedBox(height: 66);
                                } else {
                                  Need_Contact need = _needs[index];
                                  return CupertinoListTile(
                                      onTap: () {
                                        mIntPage == 0
                                            ? setState(() {
                                                need.user_is_favourite =
                                                    need.user_is_favourite
                                                        ? false
                                                        : true;
                                              })
                                            : mIntPage == 2
                                                ? setState(() {
                                                    if (!_Selected_Auto
                                                        .contains(
                                                            _needs[index])) {
                                                      setState(() {
                                                        _Selected_Auto.add(
                                                            _needs[index]);
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _Selected_Auto.remove(
                                                            _needs[index]);
                                                      });
                                                    }
                                                    _BlnSelectAll =
                                                        _Selected_Auto.length ==
                                                                _needs.length
                                                            ? true
                                                            : false;
                                                  })
                                                : setState(() {
                                                    need.user_is_block =
                                                        need.user_is_block
                                                            ? false
                                                            : true;
                                                  });
                                      },
                                      leading: need.id != ""
                                          ? Con_profile_get(
                                              pStrImageUrl:
                                                  need.user_profileimage_path,
                                              Size: 45,
                                            )
                                          : const Text(""),
                                      title: Text(
                                        need.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      subtitle: Text(
                                        need.user_bio,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Con_grey.shade600,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: mIntPage == 0
                                          ? Transform.scale(
                                              scale: 1.3,
                                              child: Material(
                                                color: Con_transparent,
                                                child: Checkbox(
                                                  value: parseBool(need
                                                      .user_is_favourite
                                                      .toString()),
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      need.user_is_favourite =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                            )
                                          : mIntPage == 2
                                              ? Transform.scale(
                                                  scale: 1.3,
                                                  child: Material(
                                                    color: Con_transparent,
                                                    child: Checkbox(
                                                      value: _Selected_Auto
                                                          .contains(
                                                              _needs[index]),
                                                      onChanged: (bool? value) {
                                                        if (!_Selected_Auto
                                                            .contains(_needs[
                                                                index])) {
                                                          setState(() {
                                                            _Selected_Auto.add(
                                                                _needs[index]);
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _Selected_Auto
                                                                .remove(_needs[
                                                                    index]);
                                                          });
                                                        }
                                                        setState(() {
                                                          _BlnSelectAll =
                                                              _Selected_Auto
                                                                          .length ==
                                                                      _needs
                                                                          .length
                                                                  ? true
                                                                  : false;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                )
                                              : Transform.scale(
                                                  scale: 1.3,
                                                  child: Material(
                                                    color: Con_transparent,
                                                    child: Checkbox(
                                                      value: parseBool(need
                                                          .user_is_block
                                                          .toString()),
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          need.user_is_block =
                                                              value!;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ));
                                }
                              })),
                    ),
                    //
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: CupertinoButton.filled(
                      padding: const EdgeInsets.all(5),
                      borderRadius: BorderRadius.circular(50),
                      child: const Icon(CupertinoIcons.checkmark_alt),
                      onPressed: mStrPage == "Auto"
                          ? () {
                              widget.Selected.call(_Selected_Auto);
                              Navigator.pop(context);
                            }
                          : () async {
                              await sql_contact_tran.SaveContactDetFavBlock(
                                  _needs);
                              await SyncDB.SyncTable(
                                  Constants.Table_Contacts_user_wise, false);
                              _setupNeeds();
                              Navigator.pushReplacement(
                                  context, RouteTransitions.slideTransition(MdiMainPage()));
                            }),
                ),
              ],
            ));
  }
}
