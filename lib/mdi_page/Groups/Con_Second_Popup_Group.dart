//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:nextapp/A_SQL_Trigger/sql_groups.dart';
// import 'package:nextapp/Constant/Con_AppBar_ChatProfile.dart';
// import 'package:nextapp/Constant/Con_Clr.dart';
// import 'package:nextapp/Constant/Con_Icons.dart';
// import 'package:nextapp/Constant/Constants.dart';
// import 'package:nextapp/Constant/Con_Usermast.dart';
// import 'package:nextapp/mdi_page/Groups/Con_Three_Group.dart';
// import '../../Constant/Con_Profile_Get.dart';
// import '../../Constant/Con_Wid.dart';
//
// class Con_Popup_Group extends StatefulWidget {
//   late String id;
//   late String name;
//   late String image;
//   late String grp_exist_user;
//
//   Con_Popup_Group(this.id, this.name, this.image, this.grp_exist_user,
//       {Key? key})
//       : super(key: key);
//
//   @override
//   _Con_Popup_Group createState() => _Con_Popup_Group();
// }
//
// class _Con_Popup_Group extends State<Con_Popup_Group> {
//   _Con_Popup_Group();
//
//   final pControllerName = TextEditingController();
//   final picker = ImagePicker();
//   List<My_Group_Contact_Sub> _needs = [];
//   String pStrDownloadUrl = "";
//   bool _blnProgress = false, Emojishow = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _setupNeeds();
//     if (widget.name.toString().trim().trimRight() != "") {
//       pControllerName.text = widget.name.toString().trim().trimRight();
//     }
//   }
//
//   _setupNeeds() async {
//     List<My_Group_Contact_Sub> needs =
//         await sql_groups_tran.GetGroupDetail_Sub(widget.id);
//     if (mounted) {
//       setState(() {
//         _needs = needs;
//         Constants_List.group_contact_sub = needs;
//       });
//     }
//     if (needs.isNotEmpty) {}
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: const Padding(
//           padding: EdgeInsets.only(left: 8.0),
//           child: BackButton(),
//         ),
//         title: const Text(
//           "Edit Group info",
//           style: TextStyle(color: Con_white),
//         ),
//         actions: const <Widget>[],
//       ),
//       backgroundColor: const Con_white,
//       floatingActionButton: FloatingActionButton(
//           backgroundColor: App_Float_Back_Color,
//           elevation: 0.0,
//           child: const Icon(Icons.check),
//           onPressed: () {
//             if (pControllerName.text.trim().trimLeft().trimRight().isEmpty) {
//               Fluttertoast.showToast(
//                 msg: 'Please enter group name',
//                 toastLength: Toast.LENGTH_SHORT,
//                 gravity: ToastGravity.BOTTOM,
//               );
//               return;
//             }
//             if (_needs.isEmpty) {
//               Fluttertoast.showToast(
//                 msg: 'Please enter group name',
//                 toastLength: Toast.LENGTH_SHORT,
//                 gravity: ToastGravity.BOTTOM,
//               );
//               return;
//             }
//             sql_groups_tran.SaveGroupDetail(
//                 widget.id,
//                 pControllerName.text.trim().trimLeft().trimRight(),
//                 pStrDownloadUrl,
//                 "UPDATE");
//             int count = 0;
//             Navigator.of(context).popUntil((_) => count++ >= 2);
//           }),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: Stack(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _blnProgress == true
//                         ? Padding(
//                             padding: const EdgeInsets.only(bottom: 5.0),
//                             child: Container(
//                                 width: 45.0,
//                                 height: 45.0,
//                                 child: const Center(
//                                     child: CircularProgressIndicator()),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: Con_black12),
//                                   shape: BoxShape.circle,
//                                   color: Con_white,
//                                 )),
//                           )
//                         : GestureDetector(
//                             onTap: () {
//                               _showDrawer_documents_pic();
//                             },
//                             child: Padding(
//                                 padding: const EdgeInsets.only(bottom: 5.0),
//                                 child: Con_profile_get(
//                                     widget.image, 45, widget.id)),
//                           ),
//                     Flexible(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: TextFormField(
//                           controller: pControllerName,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter group name';
//                             }
//                             return null;
//                           },
//                           decoration: const InputDecoration(
//                             hintText: 'Group name',
//                           ),
//                           keyboardType: TextInputType.text,
//                           maxLength: 25,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Color(0xff22242a),
//                             fontWeight: FontWeight.w300,
//                             height: 1.4285714285714286,
//                           ),
//                           textAlign: TextAlign.left,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Positioned(
//                   top: 14,
//                   right: 1,
//                   child: Con_Wid.mIconButton(
//                     icon: Icon(Own_Face,
//                         color: Emojishow == true ? AppBar_ThemeColor : null),
//                     onPressed: () {
//                       setState(() {});
//                     },
//                     color: AppBlueGreyColor2,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Constants.ChatSubBuildDivider(),
//           _needs.isNotEmpty
//               ? Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           (_needs.length.toString() + " participants"),
//                         ),
//                       )
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
//                         My_Group_Contact_Sub need = _needs[index];
//                         return Column(
//                           children: [
//                             need.is_admin == true
//                                 ? Padding(
//                                     padding: const EdgeInsets.only(left: 5.0),
//                                     child: ListTile(
//                                       leading: const Padding(
//                                         padding: EdgeInsets.only(left: 5.0),
//                                         child:
//                                             Icon(Icons.edit, color: Con_red),
//                                       ),
//                                       title: const Text("Edit group list",
//                                           style: TextStyle(fontSize: 16)),
//                                       onTap: () {
//                                         Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) => Con_Group(
//                                                     widget.id,
//                                                     widget.name,
//                                                     widget.image,
//                                                     false)));
//                                       },
//                                     ),
//                                   )
//                                 : Container(),
//                             ListTile(
//                                 dense: true,
//                                 onLongPress: () {
//                                 },
//                                 leading: Con_profile_get(
//                                     Constants_List.need_contact
//                                         .where((element) =>
//                                             element.id == _needs[index].id)
//                                         .first
//                                         .user_profileimage_path,
//                                     45,
//                                     Constants_List.need_contact
//                                         .where((element) =>
//                                             element.id == _needs[index].id)
//                                         .first
//                                         .user_mast_id
//                                         .toString()),
//                                 title: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(need.disp_name,
//                                         style: const TextStyle(fontSize: 16)),
//                                     need.is_admin == true
//                                         ? const Text("admin",
//                                             style: TextStyle(fontSize: 16))
//                                         : Container()
//                                   ],
//                                 ),
//                                 subtitle: Text(
//                                   need.user_bio,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                       fontSize: 13,
//                                       color: Con_grey.shade600,
//                                       fontWeight: FontWeight.bold),
//                                 )),
//                           ],
//                         );
//                       })),
//             ),
//           ),
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
//                         Navigator.pop(context);
//                       },
//                     ),
//                     ListTile(
//                       leading: Own_Pic_SelectProfile,
//                       title: const Text('Select Profile Picture'),
//                       onTap: () {
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
// }
