// GridView.builder(
// physics: auto_send_priview[index]
//     .mediaList
//     .any((e) =>
// e.msgType == "3" ||
// e.msgType == "4")
// ? const BouncingScrollPhysics()
//     : const NeverScrollableScrollPhysics(),
// itemCount:
// auto_send_priview[index]
//     .mediaList
//     .length,
// gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// crossAxisCount: auto_send_priview[index]
//     .mediaList
//     .any((e) =>
// e.msgType == "3" ||
// e.msgType == "4")
// ? 1
//     : grid_count(auto_send_priview[index]
//     .mediaList
//     .length),
// childAspectRatio: auto_send_priview[index]
//     .mediaList
//     .any((e) =>
// e.msgType == "3" ||
// e.msgType == "4")
// ? 1 / 0.2
//     : aspect_ratio(
// auto_send_priview[index]
//     .mediaList
//     .length),
// mainAxisSpacing: 5,
// crossAxisSpacing: 5),
// itemBuilder: (context, index1) {
// return Container(
// decoration: BoxDecoration(
// color: (auto_send_priview[index]
//     .mediaList[
// index1]
//     .msgType ==
// '3' ||
// auto_send_priview[index]
//     .mediaList[
// index1]
//     .msgType ==
// '4')
// ? getPlatformBrightness()
// ? Dark_ChatField
//     : const Color(
// 0xffecf5f7)
//     : Con_transparent
//     .withOpacity(
// 0.03),
// borderRadius: const BorderRadius.all(
// Radius.circular(10)),
// border: (auto_send_priview[index]
//     .mediaList[index1]
//     .msgType ==
// '2')
// ? Border.all(color: Con_transparent)
//     : Border.all(color: Con_msg_auto_6)),
// alignment:
// Alignment.topCenter,
// child: (auto_send_priview[
// index]
//     .mediaList[index1]
//     .msgType ==
// '2')
// ? ImageBubble(
// imageUrl:
// auto_send_priview[
// index]
//     .mediaList[
// index1]
//     .msgDocumentUrl,
// Padding: false,
// blurhash: "",
// imageName:
// auto_send_priview[
// index]
//     .mediaList[
// index1]
//     .msgAudioName,
// isRight: "1",
// isVideo: false,
// isCurve: true,
// onTapChange: true,
// )
//     : (auto_send_priview[
// index]
//     .mediaList[
// index1]
//     .msgType ==
// '3')
// ? Padding(
// padding: const EdgeInsets
//     .symmetric(
// horizontal:
// 10),
// child: Row(
// mainAxisAlignment:
// MainAxisAlignment
//     .start,
// crossAxisAlignment:
// CrossAxisAlignment
//     .center,
// children: [
// Container(
// padding:
// const EdgeInsets
//     .all(4),
// decoration:
// const BoxDecoration(
// color:
// Con_msg_auto,
// borderRadius:
// BorderRadius.all(
// Radius.circular(8)),
// ),
// child:
// Container(
// padding: const EdgeInsets
//     .only(
// top:
// 8),
// width: 34,
// height:
// 34,
// decoration:
// const BoxDecoration(
// image: DecorationImage(
// image:
// AssetImage("assets/images/no_cover11.webp")),
// ),
// ),
// ),
// Container(
// margin: const EdgeInsets
//     .only(
// left:
// 10),
// child:
// Column(
// mainAxisAlignment:
// MainAxisAlignment
//     .center,
// crossAxisAlignment:
// CrossAxisAlignment
//     .start,
// children: [
// Container(
// child:
// Text(
// auto_send_priview[index].mediaList[index1].msgAudioName.length > 31
// ? auto_send_priview[index].mediaList[index1].msgAudioName.substring(0, 30) + '...'
//     : auto_send_priview[index].mediaList[index1].msgAudioName,
// textAlign:
// TextAlign.center,
// style:
// const TextStyle(
// fontSize: 15,
// fontWeight: FontWeight.w500,
// color: Con_msg_auto_2,
// ),
// ),
// ),
// Text(
// "<unknown> • ${auto_send_priview[index].mediaList[index1].msgMediaSize}"
// " • ${auto_send_priview[index].mediaList[index1].msgAudioName.split('.').last}",
// style:
// const TextStyle(
// fontSize:
// 8.6,
// fontWeight:
// FontWeight.w500,
// color:
// Con_msg_auto,
// ),
// ),
// ],
// ),
// )
// ],
// ),
// )
//     : (auto_send_priview[
// index]
//     .mediaList[
// index1]
//     .msgType ==
// '4')
// ? Padding(
// padding: const EdgeInsets
//     .symmetric(
// horizontal:
// 10),
// child: Row(
// mainAxisAlignment:
// MainAxisAlignment
//     .start,
// crossAxisAlignment:
// CrossAxisAlignment
//     .center,
// children: [
// Container(
// padding:
// const EdgeInsets.all(4),
// decoration:
// const BoxDecoration(
// color:
// Con_msg_auto,
// borderRadius:
// BorderRadius.all(Radius.circular(8)),
// ),
// child:
// Container(
// padding:
// const EdgeInsets.only(top: 8),
// width:
// 34,
// height:
// 34,
// decoration:
// const BoxDecoration(
// image:
// DecorationImage(image: AssetImage("assets/images/Doc.webp")),
// ),
// child:
// Center(
// child:
// Text(
// auto_send_priview[index].mediaList[index1].msgAudioName.split('.').last.toUpperCase(),
// style: const TextStyle(fontSize: 8, color: Con_msg_auto),
// ),
// ),
// ),
// ),
// Container(
// margin: const EdgeInsets.only(
// left:
// 10),
// child: Column(
// mainAxisAlignment:
// MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Container(
// margin: const EdgeInsets.symmetric(vertical: 10),
// child: Text(
// auto_send_priview[index].mediaList[index1].msgAudioName.length > 31 ? auto_send_priview[index].mediaList[index1].msgAudioName.substring(0, 30) + '...' : auto_send_priview[index].mediaList[index1].msgAudioName,
// textAlign: TextAlign.center,
// style: TextStyle(
// fontSize: 15,
// fontWeight: FontWeight.w500,
// color: getPlatformBrightness() ? Con_white : Con_msg_auto_2,
// ),
// ),
// ),
// Text(
// "<unknown> • ${auto_send_priview[index].mediaList[index1].msgMediaSize}"
// " • ${auto_send_priview[index].mediaList[index1].msgAudioName.split('.').last}",
// style: TextStyle(
// fontSize: 8.6,
// fontWeight: FontWeight.w500,
// color: getPlatformBrightness() ? Con_white : Con_msg_auto,
// ),
// ),
// ]),
// ),
// ],
// ),
// )
//     : (auto_send_priview[
// index]
//     .mediaList[
// index1]
//     .msgType ==
// '5')
// ? ImageBubble(
// imageUrl: auto_send_priview[
// index]
//     .mediaList[
// index1]
//     .msgDocumentUrl,
// Padding:
// false,
// blurhash:
// "",
// imageName: auto_send_priview[
// index]
//     .mediaList[
// index1]
//     .msgAudioName,
// isRight:
// "1",
// isVideo:
// true,
// isCurve:
// true,
// onTapChange:
// true,
// )
//     : Container(),
// );
// },
// )
