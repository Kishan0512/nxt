//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:nextapp/A_FB_Trigger/DatabaseService.dart';
// import 'package:nextapp/Constant/Con_Clr.dart';
// import 'package:nextapp/Constant/Con_Icons.dart';
// import 'package:nextapp/Constant/Con_Wid.dart';
// import 'package:nextapp/Constant/Constants.dart';
// import 'package:nextapp/Constant/Con_Usermast.dart';
// import 'package:nextapp/mdi_page/Groups/Con_Second_Popup_Group.dart';
//
// import '../../Constant/Con_Profile_Get.dart';
// import 'Con_Grp_Sub_Show_Media_list.dart';
// import 'grp_msg_left_thread.dart';
// import 'grp_msg_right_thread.dart';
//
// class Con_Send_Group extends StatefulWidget {
//   late String id;
//   late String name;
//   late String image;
//   late String grp_exist_user;
//
//   Con_Send_Group(this.id, this.name, this.image, this.grp_exist_user,
//       {Key? key})
//       : super(key: key);
//
//   @override
//   _Con_Send_Group createState() => _Con_Send_Group();
// }
//
// enum PopUpData { Info, Media, Search, Wallpaper, ClearChat }
//
// class _Con_Send_Group extends State<Con_Send_Group> {
//   _Con_Send_Group();
//
//   bool isShowSticker = false, Emojishow = false;
//   final TextEditingController _txtcont = TextEditingController();
//   final List<Need_Group_Sub_Msg> _needs_sub_grp_msg = [];
//   final ScrollController _controller = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _setupNeeds_Msg();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   _setupNeeds_Msg() async {
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         leading: Con_Wid.mIconButton(
//           icon: Own_ArrowBack,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         titleSpacing: 0,
//         leadingWidth: 40,
//         title: ListTile(
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => Con_Popup_Group(
//                           widget.id.toString(),
//                           widget.name.toString(),
//                           widget.image,
//                           widget.grp_exist_user)));
//             },
//             leading: Con_profile_get(widget.image, 45,widget.id.toString()),
//             title: Text(widget.name,
//                 style: const TextStyle(color: Con_white)),
//             subtitle: const Text("tap here for group list info",
//                 style: TextStyle(color: Con_white))),
//         actions: <Widget>[
//           PopupMenuButton<PopUpData>(
//             splashRadius: 20,
//             onSelected: (PopUpData result) {
//               setState(() {
//                 switch (result) {
//                   case PopUpData.Info:
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => Con_Popup_Group(
//                                 widget.id.toString(),
//                                 widget.name.toString(),
//                                 widget.image,
//                                 widget.grp_exist_user)));
//                     break;
//                   case PopUpData.Media:
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => GroupMediaList(widget.id)));
//                     break;
//                   case PopUpData.Search:
//                     break;
//                   case PopUpData.Wallpaper:
//                     break;
//                   case PopUpData.ClearChat:
//                     ConfirmClear();
//                     break;
//                 }
//               });
//             },
//             itemBuilder: (BuildContext context) => <PopupMenuEntry<PopUpData>>[
//               const PopupMenuItem<PopUpData>(
//                   value: PopUpData.Info, child: Text('Group list info')),
//               const PopupMenuItem<PopUpData>(
//                   value: PopUpData.Media, child: Text('Group list media')),
//               const PopupMenuItem<PopUpData>(
//                   value: PopUpData.Search, child: Text('Search')),
//               const PopupMenuItem<PopUpData>(
//                   value: PopUpData.Wallpaper, child: Text('Wallpaper')),
//               const PopupMenuItem<PopUpData>(
//                 value: PopUpData.ClearChat,
//                 child: Text('Clear chat'),
//               ),
//             ],
//           ),
//         ],
//       ),
//       backgroundColor: const Con_white,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Expanded(child: ChatData()),
//           Constants_List.need_quickreply.isNotEmpty &&
//                   Constants_Usermast.user_chat_bln_quick_reply
//               ? buildInput_Suggestion()
//               : Container(),
//           WillPopScope(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 buildInput(),
//               ],
//             ),
//             onWillPop: onBackPress,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> ConfirmClear() async {
//     Con_Wid.mConfirmDialog(
//         context: context,
//         title: "Clear all chat",
//         message:
//         'Are you sure you want to clear all messages and media of ${widget.name} chat ?',
//         onOkPressed: () {
//           setState(() {
//             _needs_sub_grp_msg.clear();
//             _setupNeeds_Msg();
//             Navigator.pop(context);
//           });
//         },
//         onCancelPressed: () {
//           Navigator.pop(context);
//         });
//   }
//
//   Widget ChatData() {
//     return FutureBuilder(
//         future: _setupNeeds_Msg(),
//         builder: (context, snapshot) {
//           return ListView.builder(
//             reverse: true,
//             controller: _controller,
//             itemCount: _needs_sub_grp_msg.length,
//             itemBuilder: (BuildContext context, int index) {
//               Need_Group_Sub_Msg need = _needs_sub_grp_msg[index];
//               Widget child;
//               final isMe =
//                   need.user_last_user == Constants_Usermast.mobile_number
//                       ? false
//                       : true;
//               if (isMe != true) {
//                 child = Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: <Widget>[
//                     GrpRightThread(
//                       need.user_last_msg,
//                       backgroundColor: Chat_Row_RightSieBackColor,
//                     ),
//                   ],
//                 );
//               } else {
//
//                 child = Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: GrpLeftThread(
//                     need.user_last_user,
//                     need.user_last_msg,
//                     backgroundColor:
//                         Chat_Row_LeftSideBackColor,
//                   ),
//                 );
//               }
//               return Container(child: child);
//             },
//           );
//         });
//   }
//
//   Widget buildInput_Suggestion() {
//     return Container(
//       color: Con_white,
//       height: 50.0,
//       child: ListView.builder(
//         padding: const EdgeInsets.only(left: 4.0),
//         scrollDirection: Axis.horizontal,
//         itemCount: Constants_List.need_quickreply.length,
//         itemBuilder: (context, index) {
//           var QuickValue = Constants_List
//               .need_quickreply[index].user_quick_value
//               .toString()
//               .trim()
//               .trimLeft()
//               .trimRight();
//           return GestureDetector(
//             onTap: () {
//               SendBroadMessage(QuickValue);
//               _txtcont.clear();
//               _setupNeeds_Msg();
//               _controller.animateTo(
//                 0.0,
//                 curve: Curves.easeOut,
//                 duration: const Duration(milliseconds: 300),
//               );
//             },
//             child: Wrap(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.all(4.0),
//                   padding: const EdgeInsets.all(5.0),
//                   decoration: BoxDecoration(
//                       border: Border.all(width: 1.0),
//                       borderRadius:
//                           const BorderRadius.all(Radius.circular(30.0) //
//                               )),
//                   child: Padding(
//                     padding: const EdgeInsets.all(3.0),
//                     child: GestureDetector(
//                       onTap: () {
//                         SendBroadMessage(QuickValue);
//                         _txtcont.clear();
//                         _setupNeeds_Msg();
//                         _controller.animateTo(
//                           0.0,
//                           curve: Curves.easeOut,
//                           duration: const Duration(milliseconds: 300),
//                         );
//                       },
//                       child: Text(
//                         QuickValue,
//                         style: const TextStyle(
//                             fontSize: 15.0, color: Con_black),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget buildInput() {
//     return WillPopScope(
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 Container(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: <Widget>[
//                       Material(
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 1.0),
//                           child: Con_Wid.mIconButton(
//                             icon: Own_Image,
//                             onPressed: () {},
//                             color: AppBlueGreyColor2,
//                           ),
//                         ),
//                         color: Con_white,
//                       ),
//                       Material(
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 1.0),
//                           child: Con_Wid.mIconButton(
//                             icon: Icon(Own_Face,
//                                 color: Emojishow == true
//                                     ? AppBar_ThemeColor
//                                     : null),
//                             onPressed: () {
//                               setState(() {
//                                 isShowSticker = !isShowSticker;
//                               });
//                             },
//                             color: AppBlueGreyColor2,
//                           ),
//                         ),
//                         color: Con_white,
//                       ),
//                       Flexible(
//                         child: Container(
//                           child: TextField(
//                             controller: _txtcont,
//                             style: const TextStyle(fontSize: 18.0),
//                             decoration: const InputDecoration.collapsed(
//                               hintText: 'Type your message...',
//                               hintStyle: TextStyle(color: AppBlueGreyColor2),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Material(
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Con_Wid.mIconButton(
//                             icon: Own_Send,
//                             onPressed: () {
//                               if (_txtcont.text.trim() == "" ||
//                                   _txtcont.text.isEmpty) {
//                                 Fluttertoast.showToast(
//                                   msg: 'Nothing to send',
//                                   toastLength: Toast.LENGTH_SHORT,
//                                   gravity: ToastGravity.BOTTOM,
//                                 );
//                                 return;
//                               }
//                               SendBroadMessage(_txtcont.text
//                                   .toString()
//                                   .trim()
//                                   .trimLeft()
//                                   .trimRight());
//                             },
//                           ),
//                         ),
//                         color: Con_white,
//                       ),
//                     ],
//                   ),
//                   width: double.infinity,
//                   height: 50.0,
//                   decoration: const BoxDecoration(
//                       border: Border(
//                           top:
//                               BorderSide(color: AppBlueGreyColor2, width: 0.5)),
//                       color: Con_white),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         onWillPop: onBackPress);
//   }
//
//   Future<void> SendBroadMessage(String Value) async {
//     _txtcont.clear();
//   }
//
//   Future<bool> onBackPress() {
//     if (isShowSticker) {
//       setState(() {
//         isShowSticker = false;
//       });
//     } else {
//       Navigator.pop(context);
//     }
//
//     return Future.value(false);
//   }
// }
