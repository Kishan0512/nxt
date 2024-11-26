import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../A_FB_Trigger/SharedPref.dart';
import '../../A_SQL_Trigger/sql_usermast.dart';
import '../../Constant/Con_AppBar_ChatProfile.dart';
import '../../Constant/Con_Clr.dart';
import '../../Constant/Con_Icons.dart';
import '../../Constant/Con_Usermast.dart';
import '../../Constant/Con_Wid.dart';
import '../../Constant/Constants.dart';
import '../../Emoji/emoji_widget.dart';
import 'package:path/path.dart' as Path;

import '../Constant/Con_Profile_Get.dart';
import '../OSFind.dart';
import '../Settings/Folders/Folder.dart';
import '../Settings/set_sub_main_settings.dart';
import 'Dateofbirth.dart';

class ProfilePic extends StatefulWidget {
  late String mStrValue;

  ProfilePic(this.mStrValue, {Key? key}) : super(key: key);

  @override
  _ProfilePic createState() => _ProfilePic(mStrValue);
}

class _ProfilePic extends State<ProfilePic> {
  _ProfilePic(this.mStrValue);

  late File _image;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final picker = ImagePicker();
  String mStrDownloadUrl = "", mStrValue = "";
  bool _blnProgress = false;

  askPermission() async {
    await Folder.createdir();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      sql_usermast_tran.SelectUserTable();
      mStrDownloadUrl = Constants_Usermast.user_profileimage_path;
    });
    askPermission();
  }

  @override
  void dispose() {
    super.dispose();
  }

  CupertinoNavigationBar Cupertino_Loginappbar() {
    return CupertinoNavigationBar(
      border: Border.fromBorderSide(BorderSide.none),
      padding: EdgeInsetsDirectional.zero,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Icon(
            color: getPlatformBrightness() ? Con_white : Con_black,
            CupertinoIcons.left_chevron),
        onPressed: () {
          Navigator.pop(context, Constants_Usermast.user_bio);
        },
      ),
    );
  }

  AppBar LoginAppBar() {
    return AppBar(
        backgroundColor:
            getPlatformBrightness() ? DarkTheme_Main : LightTheme_White,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Own_ArrowBack,
          color: getPlatformBrightness() ? Con_white : Con_black,
          splashRadius: 20,
          onPressed: () {
            Navigator.pop(context, Constants_Usermast.user_bio);
          },
        ));
  }

  AppBar ProfileAppBar() {
    return AppBar(
        elevation: 0,
        leading: Con_Wid.mIconButton(
          icon: Own_ArrowBack,
          onPressed: () {
            Navigator.pushReplacement(
                context, RouteTransitions.slideTransition(sub_main_settings())

                );
          },
        ));
  }

  CupertinoNavigationBar Cupertino_profileAppBar() {
    return CupertinoNavigationBar(
      backgroundColor: App_IconColor,
      padding: EdgeInsetsDirectional.zero,
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        child: const Icon(CupertinoIcons.left_chevron, color: Con_white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Os.isIOS
        ? Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: true,
            appBar: mStrValue == "Login" ? LoginAppBar() : ProfileAppBar(),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(height: 20,),
                      mStrValue == "Login"
                          ? const Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    fontSize: 30,
                                    height: 1.3333333333333333,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Set your profile.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                textHeightBehavior: TextHeightBehavior(
                                    applyHeightToFirstAscent: false),
                                textAlign: TextAlign.left,
                              ),
                            )
                          : Container(),
                      mStrValue == "Login"
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, left: 15.0),
                              child: Text(
                                'Help other users reach to you.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: getPlatformBrightness()
                                      ? Dark_AppGreyColor
                                      : AppGreyColor,
                                  height: 1.7857142857142858,
                                ),
                                textHeightBehavior: const TextHeightBehavior(
                                    applyHeightToFirstAscent: false),
                                textAlign: TextAlign.left,
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 200.0,
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Stack(
                                  fit: StackFit.loose,
                                  children: [
                                    InkWell(
                                      borderRadius:
                                          BorderRadius.circular(100),
                                      onTap: () {
                                        _showDrawer_documents();
                                      },
                                      child: Container(
                                        height: 135,
                                        width: 135,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 3,
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
                                                decoration:
                                                    const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Con_white,
                                                ))
                                            : Con_profile_get(
                                                pStrImageUrl: Constants_Usermast
                                                    .user_profileimage_path,
                                                Size: 120,
                                              ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: Baseline(
                                        baselineType: TextBaseline.alphabetic,
                                        baseline: 120,
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration:  BoxDecoration(
                                            border: Border.all(color: Con_Main_1,width: 2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: FloatingActionButton(
                                            heroTag: '1',
                                            backgroundColor: Con_white,
                                            shape:
                                                const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                              Radius.circular(30.0),
                                            )),
                                            onPressed: () {
                                              _showDrawer_documents();
                                            },
                                            child: Constants_Usermast
                                                    .user_profileimage_path
                                                    .isNotEmpty
                                                ? const Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                    color: Con_Main_1,
                                                  )
                                                : const Icon(
                                                    Icons.camera_alt,
                                                    size: 20,
                                                    color: Con_Main_1,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListTile(

                          tileColor: Con_msg_auto_10,
                            onTap: () {
                              _navigateUsername(context);
                            },
                            dense: true,
                            leading: const Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Own_Account,
                            ),
                            title: const Text('Name',
                                style: TextStyle(
                                  fontSize: 14,
                                )),
                            subtitle: Constants_Usermast.user_login_name.isEmpty
                                ? Text("johndoe",
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: getPlatformBrightness()
                                          ? Dark_AppGreyColor
                                          : AppGreyColor,
                                    ))
                                : Text(Constants_Usermast.user_login_name,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    )),
                           ),
                      ),
                      Divider(height: 10,color: Colors.transparent),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListTile(
                            tileColor: Con_msg_auto_10,
                            onTap: () {
                              _navigateBio(context);
                            },
                            dense: true,
                            isThreeLine: true,
                            leading: const Padding(
                              padding: EdgeInsets.only(top: 1.0),
                              child: Own_About,
                            ),
                            title: const Padding(
                              padding: EdgeInsets.only(top: 6.0),
                              child: Text('About',
                                  style: TextStyle(
                                    fontSize: 14,
                                  )),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                children: [
                                  Constants_Usermast.user_bio.isEmpty
                                      ? Text("Hi! I'm using Nxt",
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: getPlatformBrightness()
                                                ? Dark_AppGreyColor
                                                : AppGreyColor,
                                          ))
                                      : Text(Constants_Usermast.user_bio,
                                          overflow: TextOverflow.clip,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          )),
                                ],
                              ),
                            ),
                           ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListTile(
                          dense: true,
                          isThreeLine: true,
                          leading: const Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Own_Phone,
                          ),
                          title: const Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text('Phone',
                                style: TextStyle(
                                  fontSize: 14,
                                )),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              children: [
                                Text(
                                    Constants_Usermast.country_code +
                                        " " +
                                        Constants_Usermast.disp_mobile_number
                                            .toString(),
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ].toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        if (Constants_Usermast.user_login_name.isEmpty) {
                          Fluttertoast.showToast(
                            msg: 'Please enter name',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          return;
                        }
                        if (Constants_Usermast.user_bio.isEmpty) {
                          Fluttertoast.showToast(
                            msg: 'Please enter userbio',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          return;
                        }
                        if (mStrValue == "Login") {
                          SharedPref.save_string('user_login_name',
                              Constants_Usermast.user_login_name);
                          SharedPref.save_string(
                              'user_about', Constants_Usermast.user_bio);
                          SharedPref.save_string('user_phone',
                              Constants_Usermast.disp_mobile_number);
                          SharedPref.save_string("profile_pic",
                              Constants_Usermast.user_profileimage_path);
                          Navigator.push(
                              context, RouteTransitions.slideTransition(Dateofbirth())

                              );
                        } else {
                          Navigator.pop(context, Constants_Usermast.user_bio);
                        }
                      },
                      child: const Button(),
                    ),
                  ),
                )
              ],
            ),
          )
        : CupertinoPageScaffold(
            navigationBar: mStrValue == "Login"
                ? Cupertino_Loginappbar()
                : Cupertino_profileAppBar(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      SizedBox(height: 8),
                      mStrValue == "Login"
                          ? const Material(
                        color: Colors.transparent,
                              child: Padding(
                                padding: EdgeInsets.only(left: 30.0),
                                child: Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                      fontSize: 30,
                                      height: 1.3333333333333333,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Set your\nprofile.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textHeightBehavior: TextHeightBehavior(
                                      applyHeightToFirstAscent: false),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            )
                          : Container(),
                      mStrValue == "Login"
                          ? Material(
                        color: Colors.transparent,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, left: 15.0),
                                child: Text(
                                  'Help other users reach to you.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: getPlatformBrightness()
                                        ? Dark_AppGreyColor
                                        : AppGreyColor,
                                    height: 1.7857142857142858,
                                  ),
                                  textHeightBehavior: const TextHeightBehavior(
                                      applyHeightToFirstAscent: false),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: SizedBox(
                          height: 200.0,
                          child: Column(
                            children: <Widget>[
                              Stack(fit: StackFit.loose, children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Cupertino_showDrawer_documents();
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
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
                                                pStrImageUrl: Constants_Usermast
                                                    .user_profileimage_path,
                                                Size: 120,
                                              ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.12,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.32),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Con_Main_1,
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
                                              backgroundColor: Con_white,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                Radius.circular(30.0),
                                              )),
                                              onPressed: () {
                                                Cupertino_showDrawer_documents();
                                              },
                                              child: Constants_Usermast
                                                      .user_profileimage_path
                                                      .isNotEmpty
                                                  ? const Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                      color: Con_Main_1,
                                                    )
                                                  : const Icon(
                                                      Icons.camera_alt,
                                                      size: 20,
                                                      color: Con_Main_1,
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
                      CupertinoListTile(
                          onTap: () {
                            _navigateUsername(context);
                          },
                          leading: const Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Own_Account,
                          ),
                          title: const Text('Name',
                              style: TextStyle(
                                fontSize: 14,
                              )),
                          subtitle: Constants_Usermast.user_login_name.isEmpty
                              ? Text("johndoe",
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: getPlatformBrightness()
                                        ? Dark_AppGreyColor
                                        : AppGreyColor,
                                  ))
                              : Text(Constants_Usermast.user_login_name,
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  )),
                          // trailing: CupertinoButton(
                          //   padding: EdgeInsets.zero,
                          //   child: const Icon(CupertinoIcons.chevron_right),
                          //   onPressed: () {
                          //     _navigateUsername(context);
                          //   },
                          // )
                      ),
                      CupertinoListTile(
                          onTap: () {
                            _navigateBio(context);
                          },
                          leading: const Padding(
                            padding: EdgeInsets.only(top: 1.0),
                            child: Own_About,
                          ),
                          title: const Padding(
                            padding: EdgeInsets.only(top: 6.0),
                            child: Text('About',
                                style: TextStyle(
                                  fontSize: 14,
                                )),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              children: [
                                Constants_Usermast.user_bio.isEmpty
                                    ? Text("Hi! I'm using Nxt",
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: getPlatformBrightness()
                                              ? Dark_AppGreyColor
                                              : AppGreyColor,
                                        ))
                                    : Text(Constants_Usermast.user_bio,
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        )),
                              ],
                            ),
                          ),
                          // trailing: CupertinoButton(
                          //   padding: EdgeInsets.zero,
                          //   child: const Icon(CupertinoIcons.chevron_right),
                          //   onPressed: () {
                          //     _navigateBio(context);
                          //   },
                          // )
                      ),
                      CupertinoListTile(
                        leading: const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Own_Phone,
                        ),
                        title: const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text('Phone',
                              style: TextStyle(
                                fontSize: 14,
                              )),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            children: [
                              Text(
                                  Constants_Usermast.country_code +
                                      " " +
                                      Constants_Usermast.disp_mobile_number
                                          .toString(),
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ].toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        if (Constants_Usermast.user_login_name.isEmpty) {
                          Fluttertoast.showToast(
                            msg: 'Please enter name',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          return;
                        }
                        if (Constants_Usermast.user_bio.isEmpty) {
                          Fluttertoast.showToast(
                            msg: 'Please enter userbio',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          return;
                        }
                        if (mStrValue == "Login") {
                          SharedPref.save_string('user_login_name',
                              Constants_Usermast.user_login_name);
                          SharedPref.save_string(
                              'user_about', Constants_Usermast.user_bio);
                          SharedPref.save_string('user_phone',
                              Constants_Usermast.disp_mobile_number);
                          SharedPref.save_string("profile_pic",
                              Constants_Usermast.user_profileimage_path);
                          Navigator.push(
                              context, RouteTransitions.slideTransition(Dateofbirth())

                              );
                        } else {
                          Navigator.pop(context, Constants_Usermast.user_bio);
                        }
                      },
                      child: const Button(),
                    ),
                  ),
                )
              ],
            ));
  }

  _navigateUsername(BuildContext context) async {
    final result =
        await Navigator.push(context, RouteTransitions.slideTransition(UserNameEdit(mStrValue))
            // RouteTransitions.slideTransition( UserNameEdit(mStrValue)),
            );
    if (result != null) {
      if (result != "") {
        setState(() {
          Constants_Usermast.user_login_name = result.toString();
        });
      }
      setState(() {});
    }
  }

  _navigateBio(BuildContext context) async {
    final result =
        await Navigator.push(context, RouteTransitions.slideTransition(BioNameEdit(mStrValue))
            // RouteTransitions.slideTransition(),
            );
    if (result != null) {
      if (result != "") {
        setState(() {
          Constants_Usermast.user_bio = result;
        });
      }
    }
  }

  Future getImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      File? _cropdImage = await _cropImage(pickedFile: pickedFile);
      if (_cropdImage != null) {
        _image = _cropdImage;
        setState(() {
          _blnProgress = true;
        });
        DeleteFromLocal();
        firebase_storage.Reference storageReference =
            firebase_storage.FirebaseStorage.instance.ref().child(
                'user_profile_pictures/${Constants_Usermast.mobile_number}/${Path.basename(_image.path)}');
        firebase_storage.UploadTask uploadTask =
            storageReference.putFile(_image);
        uploadTask.whenComplete(() => 'print');

        var dowurl = await (await uploadTask.whenComplete(() => null))
            .ref
            .getDownloadURL();
        setState(() {
          mStrDownloadUrl = dowurl.toString();
          _blnProgress = false;
          setState(() {
            Constants_Usermast.user_profileimage_path = mStrDownloadUrl;
          });
          sql_usermast_tran.mSetUserProfileDetail(mStrDownloadUrl);
        });
      } else {
        setState(() {
          _blnProgress = false;
        });
      }
    } else {
      setState(() {
        _blnProgress = false;
      });
    }
  }

  Future<File?> _cropImage({required XFile pickedFile}) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppBar_ThemeColor,
            toolbarWidgetColor: Con_white,
            initAspectRatio: CropAspectRatioPreset.original,
            activeControlsWidgetColor: AppBar_ThemeColor,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return null;
    }
  }

  _showDrawer_documents() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              color: Theme.of(context).primaryColor,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
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
                      onTap: () async {
                        await sql_usermast_tran.mSetUserProfileDetail("");
                        await DeleteFromLocal();
                        setState(() {
                          Constants_Usermast.user_profileimage_path = "";
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: getPlatformBrightness()
                          ? Dark_Pic_folder
                          : Own_Pic_folder,
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
                            RouteTransitions.slideTransition(sub_show_profile_details(
                                Constants_Usermast.user_id.isEmpty
                                    ? ""
                                    : Constants_Usermast.user_id,
                                Constants_Usermast.user_login_name.isEmpty
                                    ? ""
                                    : Constants_Usermast.user_login_name,
                                Constants_Usermast
                                        .user_profileimage_path.isEmpty
                                    ? mStrDownloadUrl
                                    : Constants_Usermast
                                        .user_profileimage_path))
                            );
                      },
                    )
                  ],
                ),
              ));
        });
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
                  sql_usermast_tran.mSetUserProfileDetail("");
                  DeleteFromLocal();
                  setState(() {
                    Constants_Usermast.user_profileimage_path = '';
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
                  Navigator.push(
                      context,
                      RouteTransitions.slideTransition(sub_show_profile_details(
                          Constants_Usermast.user_id == ""
                              ? ""
                              : Constants_Usermast.user_id,
                          Constants_Usermast.user_login_name == ""
                              ? ""
                              : Constants_Usermast.user_login_name,
                          Constants_Usermast.user_profileimage_path))

                      );
                },
                child: const Text("View Profile Picture")),
          ],
        );
      },
    );
  }

  DeleteFromLocal() async {
    File file = File(
        '${Constants_Usermast.dbpath!.path.toString()}/Image/Profile/id_${Constants_Usermast.user_id}.png');
    if (await file.exists()) {
      setState(() {
        file.delete();
      });
    }
  }
}

class Button extends StatelessWidget {
  const Button({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Con_transparent,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 150,
          height: 45,
          child: const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Continue",
              style: TextStyle(
                fontSize: 16,
                color: Con_white,
                height: 1.25,
              ),
              textHeightBehavior:
                  TextHeightBehavior(applyHeightToFirstAscent: false),
              textAlign: TextAlign.center,
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(200.0),
            color: Con_Main_1,
            boxShadow: const [
              BoxShadow(
                color: Con_Clr_App_2,
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserNameEdit extends StatefulWidget {
  const UserNameEdit(String mStrValue, {Key? key}) : super(key: key);

  @override
  _UserNameEdit createState() => _UserNameEdit();
}

class _UserNameEdit extends State<UserNameEdit> {
  TextEditingController pControllerName = TextEditingController();
  late String mStrValue;
  bool Emojishow = false;

  @override
  void initState() {
    super.initState();
    pControllerName.text = Constants_Usermast.user_login_name == ""
        ? ""
        : Constants_Usermast.user_login_name;
  }

  @override
  void dispose() {
    super.dispose();
    pControllerName.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Os.isIOS
        ? Scaffold(
            appBar: AppBar(
                title: Constants.mAppBar('Edit Username'),
                automaticallyImplyLeading: true,
                actions: <Widget>[
                  Con_Wid.mIconButton(
                    icon: Own_Save,
                    onPressed: () {
                      if (pControllerName.text.trim().trimLeft().trimRight() ==
                          "") {
                        Fluttertoast.showToast(
                          msg: 'Please enter name',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                        return;
                      }
                      if (pControllerName.text == "" ||
                          pControllerName.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: 'Please enter name',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                        return;
                      }
                      sql_usermast_tran.mSetUserNameDetail(
                          pControllerName.text.trim().trimLeft().trimRight());
                      setState(() {
                        sql_usermast_tran.SelectUserTable();
                        Constants_Usermast.user_login_name =
                            pControllerName.text;
                      });

                      Navigator.pop(context, pControllerName.text);
                    },
                  ),
                ]),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 8, right: 45.0),
                              child: TextFormField(
                                controller: pControllerName,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter name';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintStyle: TextStyle(color: AppGreyColor),
                                  hintText: 'johndoe',
                                ),
                                keyboardType: TextInputType.text,
                                maxLength: 25,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.4285714285714286,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 14,
                        right: 1,
                        child: Con_Wid.mIconButton(
                          icon: Icon(Own_Face,
                              color:
                                  Emojishow == true ? AppBar_ThemeColor : null),
                          onPressed: () async {
                            setState(() {});
                            await Future.delayed(
                                const Duration(milliseconds: 50));
                            Emojishow = !Emojishow;
                            setState(() {});
                            setState(() {});
                            FocusScope.of(context).unfocus();
                          },
                          color: AppBlueGreyColor2,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 5.0, right: 45),
                  child: Text(
                    'This is not your username or pin. This name will be visible to your Chat contacts.',
                    style: TextStyle(
                      fontSize: 12,
                      color: getPlatformBrightness()
                          ? Dark_AppGreyColor
                          : AppGreyColor,
                      height: 1.8333333333333333,
                    ),
                    textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(child: Container()),
                Offstage(
                  offstage: !Emojishow,
                  child: SizedBox(
                    height: 255,
                    child: Emoji_Widget(controller: pControllerName),
                  ),
                )
              ],
            ),
          )
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                backgroundColor: App_IconColor,
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text('Save', style: TextStyle(color: Con_white)),
                  onPressed: () {
                    if (pControllerName.text.trim().trimLeft().trimRight() ==
                        "") {
                      Fluttertoast.showToast(
                        msg: 'Please enter name',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                      return;
                    }
                    if (pControllerName.text == "" ||
                        pControllerName.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: 'Please enter name',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                      return;
                    }
                    sql_usermast_tran.mSetUserNameDetail(
                        pControllerName.text.trim().trimLeft().trimRight());
                    setState(() {
                      sql_usermast_tran.SelectUserTable();
                      Constants_Usermast.user_login_name = pControllerName.text;
                    });

                    Navigator.pop(context, pControllerName.text);
                  },
                ),
                middle: const Text(
                  'Edit Username',
                  style: TextStyle(color: Con_white),
                ),
                padding: EdgeInsetsDirectional.zero,
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child:
                      const Icon(CupertinoIcons.chevron_left, color: Con_white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10, left: 8),
                              child: CupertinoTextField(
                                placeholder: "John",
                                controller: pControllerName,
                                keyboardType: TextInputType.text,
                                maxLength: 25,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.4285714285714286,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsetsDirectional.zero,
                            child: Icon(CupertinoIcons.smiley_fill,
                                color: Emojishow == true
                                    ? AppBar_ThemeColor
                                    : null),
                            onPressed: () async {
                              setState(() {});
                              await Future.delayed(
                                  const Duration(milliseconds: 50));
                              Emojishow = !Emojishow;
                              setState(() {});
                              setState(() {});
                              FocusScope.of(context).unfocus();
                            },
                            color: AppBlueGreyColor2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Material(
                  color: Con_transparent,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 5.0, right: 45),
                    child: Text(
                      'This is not your username or pin. This name will be visible to your Chat contacts.',
                      style: TextStyle(
                        fontSize: 12,
                        color: getPlatformBrightness()
                            ? Dark_AppGreyColor
                            : AppGreyColor,
                        height: 1.8333333333333333,
                      ),
                      textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: false),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Offstage(
                  offstage: !Emojishow,
                  child: SizedBox(
                    height: 255,
                    child: Emoji_Widget(controller: pControllerName),
                  ),
                )
              ],
            ));
  }
}

class BioNameEdit extends StatefulWidget {
  const BioNameEdit(String mStrValue, {Key? key}) : super(key: key);

  @override
  _BioNameEdit createState() => _BioNameEdit();
}

class _BioNameEdit extends State<BioNameEdit> {
  final pControllerAbout = TextEditingController();
  late String mStrValue;
  bool Emojishow = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pControllerAbout.text =
    Constants_Usermast.user_bio == "" ? "" : Constants_Usermast.user_bio;
  }
  @override
  void dispose() {
    super.dispose();
    pControllerAbout.clear();
  }

  @override
  Widget build(BuildContext context) {


    return Os.isIOS
        ? Scaffold(
            appBar: AppBar(
                title: Constants.mAppBar('Add About'),
                leading: Con_Wid.mIconButton(
                  icon: Own_ArrowBack,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: <Widget>[
                  Con_Wid.mIconButton(
                    icon: Own_Save,
                    onPressed: () {
                      sql_usermast_tran.mSetUserBioDetail(
                          pControllerAbout.text.trim().trimLeft().trimRight());
                      Navigator.pop(context, pControllerAbout.text);
                    },
                  ),
                ]),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, left: 8, right: 45.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.go,
                                  keyboardType: TextInputType.multiline,
                                  controller: pControllerAbout,
                                  validator: (value) {
                                    return null;
                                  },
                                  minLines: 1,
                                  maxLines: 4,
                                  decoration: const InputDecoration(
                                    hintText: 'Hi! I' 'm using Nxt',
                                    hintStyle: TextStyle(color: AppGreyColor),
                                  ),
                                  maxLength: 150,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 1.4285714285714286,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 14,
                          right: 1,
                          child: Con_Wid.mIconButton(
                            icon: Icon(Own_Face,
                                color: Emojishow == true
                                    ? AppBar_ThemeColor
                                    : null),
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {});
                              await Future.delayed(
                                  const Duration(milliseconds: 50));
                              Emojishow = !Emojishow;
                              setState(() {});
                              setState(() {});
                            },
                            color: AppBlueGreyColor2,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Offstage(
                  offstage: !Emojishow,
                  child: SizedBox(
                    height: 255,
                    child: Emoji_Widget(controller: pControllerAbout),
                  ),
                )
              ],
            ),
          )
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                trailing: CupertinoButton(
                  padding: EdgeInsetsDirectional.zero,
                  child: const Text("Save", style: TextStyle(color: Con_white)),
                  onPressed: () {
                    sql_usermast_tran.mSetUserBioDetail(
                        pControllerAbout.text.trim().trimLeft().trimRight());
                    Navigator.pop(context, pControllerAbout.text);
                  },
                ),
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
                  "Add About",
                  style: TextStyle(color: Con_white),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 5),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 12.0, left: 8),
                                child: CupertinoTextField(
                                  placeholder: "I'm Using Nxt",
                                  textInputAction: TextInputAction.go,
                                  keyboardType: TextInputType.multiline,
                                  controller: pControllerAbout,
                                  minLines: 1,
                                  maxLines: 4,
                                  maxLength: 150,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 1.4285714285714286,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            CupertinoButton(
                              padding: EdgeInsetsDirectional.zero,
                              child: Icon(CupertinoIcons.smiley_fill,
                                  color: Emojishow == true
                                      ? AppBar_ThemeColor
                                      : null),
                              onPressed: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                setState(() {});
                                await Future.delayed(
                                    const Duration(milliseconds: 50));
                                Emojishow = !Emojishow;
                                setState(() {});
                                setState(() {});
                              },
                              color: AppBlueGreyColor2,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Offstage(
                  offstage: !Emojishow,
                  child: SizedBox(
                    height: 255,
                    child: Emoji_Widget(controller: pControllerAbout),
                  ),
                )
              ],
            ));
  }
}
