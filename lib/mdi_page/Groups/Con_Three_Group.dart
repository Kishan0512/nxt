//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:nextapp/A_FB_Trigger/SharedPref.dart';
// import 'package:nextapp/A_FB_Trigger/sql_need_contact.dart';
// import 'package:nextapp/A_SQL_Trigger/sql_contact.dart';
// import 'package:nextapp/A_SQL_Trigger/sql_groups.dart';
// import 'package:nextapp/Constant/Con_AppBar_ChatProfile.dart';
// import 'package:nextapp/Constant/Con_ChatProfile.dart';
// import 'package:nextapp/Constant/Con_Clr.dart';
// import 'package:nextapp/Constant/Con_Icons.dart';
// import 'package:nextapp/Constant/Con_Wid.dart';
// import 'package:nextapp/Constant/Constants.dart';
// import 'package:nextapp/Constant/Con_Usermast.dart';
// import 'package:nextapp/Emoji/emoji_widget.dart';
// import 'package:path/path.dart' as Path;
//
// import '../../A_Local_DB/Sync_Json.dart';
// import '../../Constant/Con_Profile_Get.dart';
//
// class Con_Group extends StatefulWidget {
//   late String id;
//   late String name;
//   late String image;
//   late bool is_show;
//
//   Con_Group(this.id, this.name, this.image, this.is_show, {Key? key})
//       : super(key: key);
//
//   @override
//   _Con_Group createState() => _Con_Group();
// }
//
// class _Con_Group extends State<Con_Group> {
//   _Con_Group();
//
//   List<String> needsgrpExistList = [];
//   List<String> needsgrpExistList_Remove = [];
//   List<Need_Contact> _needs = [];
//   bool _BlnSelectAll = false, isSearching = false;
//   String mStrRandomId = "", pStrDownloadUrl = "";
//   final pControllerName = TextEditingController();
//   final picker = ImagePicker();
//   final TextEditingController _searchQuery = TextEditingController();
//   bool _blnProgress = false, Emojishow = false;
//   late File _image;
//
//   @override
//   void initState() {
//     super.initState();
//     isSearching = false;
//     setState(() {
//       _setupNeeds();
//     });
//     if (widget.name.toString().trim().trimRight() != "") {
//       pControllerName.text = widget.name.toString().trim().trimRight();
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _searchQuery.clear();
//   }
//
//   _SearchListState() {
//     _searchQuery.addListener(() {
//       if (_searchQuery.text.isEmpty) {
//         setState(() {
//           _setupNeeds();
//         });
//       } else {
//         setState(() {
//           isSearching = true;
//           _setupNeeds();
//         });
//       }
//     });
//   }
//
//   _setupNeeds() async {
//     String StrCon = await SharedPref.read('my_contacts');
//     if (StrCon.isNotEmpty) {
//       List<Need_Contact> needs = Need_Contact.decode(StrCon);
//       if (mounted) {
//         setState(() {
//           Constants_List.need_contact = needs;
//           _needs = needs;
//         });
//       }
//     } else {
//       List<Need_Contact> needs = await SyncJSon.user_contact_select(0);
//       if (mounted) {
//         setState(() {
//           Constants_List.need_contact = needs;
//           _needs = needs;
//           String json = jsonEncode(
//                   Constants_List.need_contact.map((i) => i.toJson1()).toList())
//               .toString();
//           SharedPref.save('my_contacts', json);
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         title: isSearching
//             ? TextField(
//                 autofocus: true,
//                 controller: _searchQuery,
//                 keyboardType: TextInputType.text,
//                 onChanged: (value) {
//                   setState(() {
//                     _SearchListState();
//                   });
//                 },
//                 style: const TextStyle(color: Con_black),
//                 decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     focusedBorder: InputBorder.none,
//                     enabledBorder: InputBorder.none,
//                     errorBorder: InputBorder.none,
//                     disabledBorder: InputBorder.none,
//                     hintText: "Search.."),
//               )
//             : (widget.id == ""
//                 ? Con_Wid.mAppBar("New Group")
//                 : Con_Wid.mAppBar("Edit Group")),
//         actions: <Widget>[
//           isSearching
//               ? _searchQuery.text.trim().trimLeft().trimRight().isNotEmpty
//                   ? Con_Wid.mIconButton(
//                       icon: Own_Delete_Search,
//                       onPressed: () {
//                         setState(() {
//                           _searchQuery.text = "";
//                           _SearchListState();
//                         });
//                       },
//                     )
//                   : const Text("")
//               : Con_Wid.mIconButton(
//                   icon: Own_Search,
//                   onPressed: () {
//                     setState(() {
//                       isSearching = true;
//                     });
//                   },
//                 ),
//         ],
//       ),
//       backgroundColor: const Con_white,
//       floatingActionButton: Emojishow == false
//           ? FloatingActionButton(
//               backgroundColor: App_Float_Back_Color,
//               elevation: 0.0,
//               child: const Icon(Icons.check),
//               onPressed: () async {
//                 needsgrpExistList.clear();
//                 needsgrpExistList_Remove.clear();
//                 if (pControllerName.text
//                     .trimRight()
//                     .trimLeft()
//                     .trim()
//                     .isEmpty) {
//                   Fluttertoast.showToast(
//                     msg: 'Please enter group name',
//                     toastLength: Toast.LENGTH_SHORT,
//                     gravity: ToastGravity.BOTTOM,
//                   );
//                   return;
//                 }
//                 if (_needs.length < 0) {
//                   Fluttertoast.showToast(
//                     msg: 'Please enter group name',
//                     toastLength: Toast.LENGTH_SHORT,
//                     gravity: ToastGravity.BOTTOM,
//                   );
//                   return;
//                 }
//                 int pTrueCount = 0;
//                 if (_needs.isNotEmpty) {
//                   for (var i = 0; i < _needs.length; i++) {
//                     {
//                       if (_needs[i].id != "") {
//                         if (_needs[i].is_group) {
//                           if (!needsgrpExistList
//                               .contains(_needs[i].id.toString())) {
//                             needsgrpExistList.add(_needs[i].id.toString());
//                           }
//                           pTrueCount++;
//                         } else {
//                           if (!needsgrpExistList_Remove
//                               .contains(_needs[i].id.toString())) {
//                             needsgrpExistList_Remove
//                                 .add(_needs[i].id.toString());
//                           }
//                         }
//                       }
//                     }
//                   }
//                 }
//                 if (pTrueCount < 1) {
//                   Fluttertoast.showToast(
//                     msg: 'Please select atleast one contacts',
//                     toastLength: Toast.LENGTH_SHORT,
//                     gravity: ToastGravity.BOTTOM,
//                   );
//                   return;
//                 }
//
//                 sql_groups_tran.SaveGroupDetail(
//                     "",
//                     pControllerName.text.trim().trimLeft().trimRight(),
//                     pStrDownloadUrl,
//                     "INSERT");
//                 List<My_Group_Contact> needs =
//                     await sql_groups_tran.GetGroupDetail();
//                 if (mounted) {
//                   setState(() {
//                     if (needs.isNotEmpty) {
//                       Constants_List.group_contact = needs;
//                       String json = jsonEncode(Constants_List.group_contact
//                               .map((i) => i.toJson1())
//                               .toList())
//                           .toString();
//                       SharedPref.save('my_grp', json);
//                     }
//                   });
//                 }
//                 int count = 0;
//                 Navigator.of(context).popUntil((_) => count++ >= 2);
//               })
//           : null,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           widget.is_show == true
//               ? Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Stack(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _blnProgress == true
//                               ? Padding(
//                                   padding: const EdgeInsets.only(bottom: 5.0),
//                                   child: Container(
//                                       width: 45.0,
//                                       height: 45.0,
//                                       child: const Center(
//                                           child: CircularProgressIndicator()),
//                                       decoration: BoxDecoration(
//                                         border:
//                                             Border.all(color: Con_black12),
//                                         shape: BoxShape.circle,
//                                         color: Con_white,
//                                       )),
//                                 )
//                               : GestureDetector(
//                                   onTap: () {
//                                     _showDrawer_documents_pic();
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(bottom: 5.0),
//                                     child: widget.image == ""
//                                         ? Container(
//                                             child: Con_Wid.mIconButton(
//                                               icon: const Icon(Icons.camera_alt,
//                                                   color: Con_white),
//                                               onPressed: () {
//                                                 _showDrawer_documents_pic();
//                                               },
//                                             ),
//                                             width: 45.0,
//                                             height: 45.0,
//                                             decoration: BoxDecoration(
//                                               border: Border.all(
//                                                   color: Con_black12),
//                                               shape: BoxShape.circle,
//                                               color: App_IconColor,
//                                             ))
//                                         : Con_profile_get(
//                                             widget.image, 45, widget.id),
//                                   ),
//                                 ),
//                           Flexible(
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: TextFormField(
//                                 onTap: () {
//                                   Emojishow = false;
//                                   setState(() {});
//                                 },
//                                 controller: pControllerName,
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter group name';
//                                   }
//                                   return null;
//                                 },
//                                 decoration: const InputDecoration(
//                                   hintText: 'Group name',
//                                 ),
//                                 keyboardType: TextInputType.text,
//                                 maxLength: 25,
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Color(0xff22242a),
//                                   fontWeight: FontWeight.w300,
//                                   height: 1.4285714285714286,
//                                 ),
//                                 textAlign: TextAlign.left,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Positioned(
//                         top: 14,
//                         right: 1,
//                         child: Con_Wid.mIconButton(
//                           icon: Icon(Own_Face,
//                               color:
//                                   Emojishow == true ? AppBar_ThemeColor : null),
//                           onPressed: () async {
//                             FocusManager.instance.primaryFocus?.unfocus();
//                             setState(() {});
//                             await Future.delayed(
//                                 const Duration(milliseconds: 50));
//                             Emojishow = !Emojishow;
//                             setState(() {});
//                           },
//                           color: AppBlueGreyColor2,
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               : Container(),
//           widget.is_show == true
//               ? _needs.isNotEmpty
//                   ? Constants.ChatSubBuildDivider()
//                   : Container()
//               : Container(),
//           _needs.isNotEmpty
//               ? Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text("Contacts (" +
//                             (_needs.where((element) => element.id != "").length)
//                                 .toString() +
//                             ")"),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 5.0, right: 17.0),
//                         child: Transform.scale(
//                           scale: 1.3,
//                           child: Checkbox(
//                             checkColor: Con_white,
//                             shape: const CircleBorder(),
//                             value: _BlnSelectAll,
//                             onChanged: (bool? value) {
//                               setState(() {
//                                 _BlnSelectAll = value!;
//                                 if (_needs.isNotEmpty) {
//                                   for (var i = 0; i < _needs.length; ++i) {
//                                     _needs[i].is_group = _BlnSelectAll;
//                                   }
//                                 }
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : Container(),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 4.0),
//               child: RefreshIndicator(
//                   onRefresh: () => _setupNeeds(),
//                   child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: _needs.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         Need_Contact need = _needs[index];
//                         return ListTile(
//                           dense: true,
//                           onTap: () {
//                             setState(() {
//                               _needs[index].is_group =
//                                   (_needs[index].is_group == true
//                                       ? false
//                                       : true);
//                             });
//                           },
//                           leading: need.id != ""
//                               ? Con_profile_get(need.user_profileimage_path, 45,
//                                   need.user_mast_id.toString())
//                               : const Text(""),
//                           title: need.name != " "
//                               ? Text(
//                                   need.name,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(fontSize: 16),
//                                 )
//                               : const Text(""),
//                           subtitle: need.id != ""
//                               ? Text(
//                                   need.user_bio,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                       fontSize: 13,
//                                       color: Con_grey.shade600,
//                                       fontWeight: FontWeight.bold),
//                                 )
//                               : const Text(""),
//                           trailing: Transform.scale(
//                             scale: 1.3,
//                             child: Checkbox(
//                               checkColor: Con_white,
//                               shape: const CircleBorder(),
//                               value: _needs[index].is_group,
//                               onChanged: (bool? value) {
//                                 setState(() {
//                                   _needs[index].is_group = value!;
//                                 });
//                               },
//                             ),
//                           ),
//                         );
//                       })),
//             ),
//           ),
//           Offstage(
//             offstage: !Emojishow,
//             child: SizedBox(
//               height: 255,
//               child: Emoji_Widget(controller: pControllerName),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   _showDrawer_documents_pic() {
//     showModalBottomSheet(
//         context: context,
//         builder: (context) {
//           return Container(
//               color: const Color(0xFF737373),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).canvasColor,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(16.0),
//                     topRight: Radius.circular(16.0),
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(top: 5.0),
//                       child: Center(
//                         child: Container(
//                             width: 30,
//                             height: 5,
//                             decoration: const BoxDecoration(
//                               color: App_DrawerDocumentColor,
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(5)),
//                             )),
//                       ),
//                     ),
//                     ListTile(
//                       leading: Own_Pic_Remove,
//                       title: const Text('Remove Profile Picture'),
//                       onTap: () {
//                         setState(() {
//                           widget.image = "";
//                         });
//
//                         Navigator.pop(context);
//                       },
//                     ),
//                     ListTile(
//                       leading: Own_Pic_SelectProfile,
//                       title: const Text('Select Profile Picture'),
//                       onTap: () {
//                         getImage();
//                         Navigator.pop(context);
//                       },
//                     ),
//                     ListTile(
//                       leading: Own_Pic_ViewProfile,
//                       title: const Text('View Profile Picture'),
//                       onTap: () {
//                         Navigator.pop(context);
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => sub_show_profile_details(
//                                     widget.id,
//                                     pControllerName.text
//                                         .toString()
//                                         .trim()
//                                         .trimLeft()
//                                         .trimRight(),
//                                     widget.image != ""
//                                         ? widget.image
//                                         : Constants_Usermast
//                                             .user_groupimage_path_global)));
//                       },
//                     )
//                   ],
//                 ),
//               ));
//         });
//   }
//
//   Future getImage() async {
//     final pickedFile =
//         await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
//     setState(() {
//       _image = File(pickedFile!.path);
//       _blnProgress = true;
//     });
//     firebase_storage.Reference storageReference =
//         firebase_storage.FirebaseStorage.instance.ref().child(
//             'user_group_pictures/${widget.id != "" ? widget.id : mStrRandomId}/${Path.basename(_image.path)}');
//     firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);
//     uploadTask.whenComplete(() => 'print');
//     var dowurl =
//         await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
//
//     setState(() {
//       {
//         pStrDownloadUrl = dowurl.toString();
//         _blnProgress = false;
//         widget.image = pStrDownloadUrl;
//       }
//     });
//   }
// }
