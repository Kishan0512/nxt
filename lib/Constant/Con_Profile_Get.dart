import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../OSFind.dart';
import 'Con_Clr.dart';
import 'Con_Usermast.dart';

class Con_profile_get extends StatefulWidget {
  String pStrImageUrl;
  double Size;
  bool? selected, isSquare, isbroadcast;

  Con_profile_get({
    super.key,
    required this.pStrImageUrl,
    required this.Size,
    this.selected,
    this.isbroadcast,
    this.isSquare,
  });

  @override
  State<Con_profile_get> createState() => _Con_profile_getState();
}

class _Con_profile_getState extends State<Con_profile_get> {
  File file = File("");

  @override
  Widget build(BuildContext context) {
    bool isfile = false;
    bool mblnselected = widget.selected ?? false;
    bool mblnisbroadcast = widget.isbroadcast ?? false;
    bool mblnisSquare = widget.isSquare ?? false;
    file = File(
        '${Constants_Usermast.dbpath!.path.toString()}/Image/Profile/${mblnisbroadcast ? "br_" : "id_"}${widget.pStrImageUrl.split('/').last.split('%').last.split('?').first.split('.').first}.webp');
    if (file.existsSync()) {
      setState(() {
        isfile = true;
      });
    } else {
      if (widget.pStrImageUrl.isNotEmpty) {
        DownloadImage(file);
      }
      setState(() {
        isfile = false;
      });
    }

    // if (false) {
    if (isfile) {
      return Container(
          width: widget.Size,
          height: widget.Size,
          decoration: BoxDecoration(
            border: Border.all(color: Con_black12),
            image: DecorationImage(fit: BoxFit.cover, image: FileImage(file)),
            shape: mblnisSquare ? BoxShape.rectangle : BoxShape.circle,
            color: Con_white,
            // border: Border.all(color: Con_black12),
          ));
    } else {
      try {
        // if (true) {
        if (widget.pStrImageUrl.isEmpty) {
          // widget.pStrImageUrl = Constants_Usermast.user_profileimage_path_global;
          return BlankProfile(
              widget.Size == 0
                  ? MediaQuery.of(context).size.width
                  : widget.Size,
              mblnisbroadcast,
              mblnselected,
              mblnisSquare);
        } else {
          return CachedNetworkImage(
            imageUrl: widget.pStrImageUrl,
            imageBuilder: (context, imageProvider) => Container(
              width: widget.Size == 0
                  ? MediaQuery.of(context).size.width
                  : widget.Size,
              height: widget.Size == 0
                  ? MediaQuery.of(context).size.width
                  : widget.Size,
              decoration: BoxDecoration(
                border: widget.Size == 0
                    ? null
                    : Border.all(width: 1, color: Con_grey.shade500),
                shape: widget.Size == 0
                    ? BoxShape.rectangle
                    : mblnisSquare
                        ? BoxShape.rectangle
                        : mblnisSquare == true
                            ? BoxShape.rectangle
                            : BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  colorFilter: mblnselected
                      ? const ColorFilter.mode(
                          Color(0xFF83BECE), BlendMode.darken)
                      : const ColorFilter.mode(
                          Con_transparent, BlendMode.overlay),
                ),
              ),
              child: Center(
                child: mblnselected
                    ?  const Icon(
                        Icons.done_rounded,
                        color: Color(0xFF458493),
                        size: 35,
                      )
                    : Container(),
              ),
            ),
            placeholder: (context, url) => Container(
                child: BlankProfile(
                    widget.Size, mblnisbroadcast, mblnselected, mblnisSquare)),
            errorWidget: (context, url, error) {
              return BlankProfile(
                  widget.Size, mblnisbroadcast, mblnselected, mblnisSquare);
            },
          );
        }
      } catch (e) {
        return BlankProfile(
            widget.Size, mblnisbroadcast, mblnselected, mblnisSquare);
      }
    }
  }

  DownloadImage(File file) async {
    try {
      if (widget.pStrImageUrl.isNotEmpty) {
        var response = await http.get(Uri.parse(widget.pStrImageUrl));
        if (response.statusCode == 200) {
          file.writeAsBytesSync(response.bodyBytes, mode: FileMode.append);
        } else {
          throw ("some arbitrary error");
        }
      }
    } catch (e) {}
  }

  Widget BlankProfile(
      double size, bool mblnisbroadcast, bool mblnselected, bool mblnisSquare) {
    return Os.isIOS
        ? Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              border: Border.all(color: Con_black12),
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: mblnselected
                    ? const ColorFilter.mode(Con_white, BlendMode.darken)
                    : const ColorFilter.mode(
                        Con_transparent, BlendMode.overlay),
                image: mblnisbroadcast
                    ? AssetImage(Constants_Usermast.user_broadimage_path_global)
                    : const AssetImage("assets/images/blank_white_image.jpg"),
              ),
              shape: mblnisSquare ? BoxShape.rectangle : BoxShape.circle,
              // border: Border.all(color: Con_black12),
            ),
            child: Center(
              child: mblnselected
                  ? const Icon(
                      Icons.done_rounded,
                      color: Color(0xFF458493),
                      size: 40,
                    )
                  : Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(Constants_Usermast
                                  .user_profileimage_path_global))),
                    ),
            ),
          )
        : Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              border: Border.all(color: Con_black12),
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: mblnselected
                    ? const ColorFilter.mode(Con_white, BlendMode.darken)
                    : const ColorFilter.mode(
                        Con_transparent, BlendMode.overlay),
                image: mblnisbroadcast
                    ? AssetImage(Constants_Usermast.user_broadimage_path_global)
                    : const AssetImage("assets/images/blank_white_image.jpg"),
              ),
              shape: mblnisSquare ? BoxShape.rectangle : BoxShape.circle,
              // border: Border.all(color: Con_black12),
            ),
            // child: Center(
            //   child: mblnselected
            //       ? const Icon(
            //     Icons.done_rounded,
            //     color: Color(0xFF458493),
            //     size: 40,
            //   )
            //       : Container(
            //     decoration: BoxDecoration(
            //         image: DecorationImage(
            //             image: AssetImage(
            //                 Constants_Usermast.user_profileimage_path_global))),
            //   ),
            // ),
          );
  }
}
