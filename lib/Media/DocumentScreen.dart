import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:nextapp/A_SQL_Trigger/sql_sub_messages.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:path/path.dart' as Path;

import '../Constant/Con_Clr.dart';
import '../Constant/Con_Icons.dart';
import '../Constant/Con_Wid.dart';
import '../Settings/Folders/Folder.dart';

class DisplayDocumentScreen extends StatefulWidget {
  final int count;
  final String usermastid;
  final List<File> DocumnetList;
  final String is_broadcast;
  String serverKey;
  String sender_name;

  DisplayDocumentScreen(this.count, this.usermastid, this.is_broadcast,
      {super.key,
      required this.DocumnetList,
      required this.sender_name,
      required this.serverKey});

  @override
  State<DisplayDocumentScreen> createState() => _DisplayDocumentScreenState();
}

String mStrDownloadUrl = "";
String mStrSelectedDoc = '';
int mIntSelectedindex = 0;

class _DisplayDocumentScreenState extends State<DisplayDocumentScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          if (widget.DocumnetList.isNotEmpty) widget.DocumnetList.clear();
          mStrSelectedDoc = '';
          return Future(() => true);
        },
        child: Scaffold(
          backgroundColor: Con_black,
          appBar: AppBar(
            titleSpacing: 0,
            leadingWidth: 42,
            leading: Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Con_Wid.mIconButton(
                icon: Own_ArrowBack,
                onPressed: () {
                  if (widget.DocumnetList.isNotEmpty) {
                    widget.DocumnetList.clear();
                  }
                  mStrSelectedDoc = '';
                  Navigator.pop(context);
                },
              ),
            ),
            title: Text(
                widget.DocumnetList[mIntSelectedindex].path.split('/').last,
                style: const TextStyle(fontSize: 16)),
            backgroundColor: Con_transparent,
          ),
          body: Stack(
            children: [
              Positioned(
                bottom: 70,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xff153f4a),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 5,
                          height: MediaQuery.of(context).size.width / 4,
                          padding:  const EdgeInsets.only(top: 30),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/doc1.webp'))),
                          child: Center(
                            child: Text(
                                widget.DocumnetList[mIntSelectedindex].path
                                    .split('/')
                                    .last
                                    .split('.')
                                    .last
                                    .toUpperCase(),
                                style: const TextStyle(
                                    color: Con_white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 10),
                          child: Text(
                              textAlign: TextAlign.center,
                              widget.DocumnetList[mIntSelectedindex].path
                                  .split('/')
                                  .last,
                              style: const TextStyle(
                                  color: Con_grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 10,
                              vertical: 10),
                          child: Text(
                              textAlign: TextAlign.center,
                              widget.DocumnetList[mIntSelectedindex]
                                          .lengthSync() <
                                      1001
                                  ? "${widget.DocumnetList[mIntSelectedindex].lengthSync()} BYTE"
                                  : widget.DocumnetList[mIntSelectedindex]
                                              .lengthSync() <
                                          1000001
                                      ? "${(widget.DocumnetList[mIntSelectedindex].lengthSync() / 1000).toStringAsFixed(2)} KB"
                                      : "${(widget.DocumnetList[mIntSelectedindex].lengthSync() / 1000000).toStringAsFixed(2)} MB",
                              style: const TextStyle(
                                  color: Con_grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        )
                      ]),
                ),
              ),
              WillPopScope(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Con_Wid_Box(
                        messageType: MessageType.chat,
                        usermastid: widget.usermastid,
                        serverKey: widget.serverKey.toString(),
                        sender_name: widget.sender_name,
                        ismedia: true,
                        onSendMessage: (String value) async {
                          for (var e in widget.DocumnetList) {
                            getDocument(e.path.toString());
                          }
                          if (value.isNotEmpty) {
                            await sql_sub_messages_tran.Send_Msg(
                                msg_content:
                                    value.trim().trimLeft().trimRight(),
                                msg_type: "1",
                                msg_document_url: '',
                                from_id: Constants_Usermast.user_id,
                                to_id: widget.usermastid,
                                is_broadcast: widget.is_broadcast,
                                broadcast_id: '',
                                sender_name: widget.sender_name,
                                server_key: widget.serverKey);
                          }
                          setState(() {});
                          int count = 0;
                          Navigator.of(context)
                              .popUntil((_) => count++ >= widget.count);
                        },
                      ),
                    ),
                  ],
                ),
                onWillPop: () {
                  return Future.value();
                },
              ),
              widget.DocumnetList.length > 1
                  ? Positioned(
                      right: 1,
                      left: 1,
                      bottom: 100,
                      child: SizedBox(
                          height: 80,
                          child: ListView.builder(
                            itemCount: widget.DocumnetList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    mStrSelectedDoc =
                                        widget.DocumnetList[index].path;
                                    mIntSelectedindex = index;
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              width: 1.2,
                                              color: Con_msg_auto_6),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      margin: const EdgeInsets.all(3),
                                      padding: const EdgeInsets.all(2.6),
                                      width: 80,
                                      child: Container(
                                        decoration: ShapeDecoration(
                                          color: Con_msg_auto_6,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                width: 1.2,
                                                color: Con_msg_auto_6),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/Doc.webp'))),
                                              child: Center(
                                                child: Text('DOC',
                                                    style: TextStyle(
                                                        color: const Color(
                                                                0xFF4697AC)
                                                            .withOpacity(0.60),
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                            ),
                                            Text(
                                                widget.DocumnetList[index].path
                                                    .split('/')
                                                    .last
                                                    .split('.')
                                                    .last
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                    color: Con_white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600))
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: InkWell(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Con_white),
                                          height: 12,
                                          width: 12,
                                          child: Own_Close_doc,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            mIntSelectedindex == index
                                                ? widget.DocumnetList.removeAt(
                                                    mIntSelectedindex)
                                                : widget.DocumnetList.removeAt(
                                                    index);
                                            if (widget.DocumnetList.length >
                                                    2 &&
                                                index < mIntSelectedindex) {
                                              mIntSelectedindex =
                                                  mIntSelectedindex - 1;
                                            } else {}
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Future getDocument(String _path) async {
    late File _file;
    firebase_storage.Reference storageReference =
        firebase_storage.FirebaseStorage.instance.ref().child(
            '${widget.is_broadcast != "0" ? 'user_Broadcast_document' : 'user_message_document'}/ ${Constants_Usermast.mobile_number}/${widget.is_broadcast != "0" ? widget.usermastid : widget.is_broadcast}/${Path.basename(_path)}');
    _file = File((_path));
    var filesize = _file.lengthSync() < 1001
        ? "${_file.lengthSync()} BYTE"
        : _file.lengthSync() < 1000001
            ? "${(_file.lengthSync() / 1000).toStringAsFixed(2)} KB"
            : "${(_file.lengthSync() / 1000000).toStringAsFixed(2)} MB";
    firebase_storage.UploadTask uploadTask = storageReference.putFile(_file);
    uploadTask.whenComplete(() => 'print');
    var dowurl =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    if (dowurl.isNotEmpty) {
      mStrDownloadUrl = dowurl.toString();
      await sql_sub_messages_tran.Send_Msg(
          msg_content: "",
          msg_type: "4",
          msg_document_url: mStrDownloadUrl.toString(),
          msg_audio_name: Path.basename(_path),
          msg_media_size: filesize,
          from_id: Constants_Usermast.user_id,
          to_id: widget.is_broadcast != "0" ? "" : widget.usermastid,
          is_broadcast: widget.is_broadcast != "0" ? "1" : "0",
          broadcast_id: widget.is_broadcast != "0" ? widget.is_broadcast : "",
          server_key: widget.serverKey,
          sender_name: widget.sender_name);
      String sentpath =
          Path.join(Folder.sentdocument.path, Path.basename(_path));
      await File(_path).copy(sentpath);
    }
  }
}
